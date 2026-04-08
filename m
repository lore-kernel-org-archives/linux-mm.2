Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A621073C8D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1C76B0092; Wed,  8 Apr 2026 07:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C533F6B0093; Wed,  8 Apr 2026 07:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68CE6B0095; Wed,  8 Apr 2026 07:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A63AA6B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:01:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 375631B862E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:01:29 +0000 (UTC)
X-FDA: 84635097498.16.250C5CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5148EC0012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:01:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bNuae1i/";
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775646087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCo/KGdYTRJFNwKNUpDIZvF/sPfe++F6/SVEF+nLq80=;
	b=66gw6jb6WlQIy+LrKzU082c6SZOIU+0o39w588HJv/tvySBxtiAS7f3WfMXjXeexiOILUN
	GxPQ6AQPHwDEA+SSjpT0FcUF03VZ5zyYSHhoAfi6fhIHqTEevrxwvdqEOXjlhSMKG9A1wj
	2Bp00xfxtzzNwnvPOjalPIGZ43eE9d0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bNuae1i/";
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775646087; a=rsa-sha256;
	cv=none;
	b=LrS0YFtdiRRbZ63tl3OLFYntLqO+XYnBP79UtFIjpLXc4oJcWMlBlk1kdy6ZT5xg8xFnQa
	d4H04fvAv0qsdX5Jqxwg8gyqH+9sfOLg93bhuNt6myGou2kTZtJCT5lAqgy4fXucn0NH7F
	5RlqnmZRSB9y0ovj2wKUvbNTk+bIryM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BFE92BC4;
	Wed,  8 Apr 2026 04:01:20 -0700 (PDT)
Received: from [10.57.87.42] (unknown [10.57.87.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F3CF3F632;
	Wed,  8 Apr 2026 04:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775646086; bh=sj8JDaDSYK+tYnVjXLuC+PQF+McDxx+lR1PogM9spE4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bNuae1i/ZuzLq7CMWlbVxrPHfN8BimWSWAP3gURWRbaWCS2zs31gmVArdTgAM9DFA
	 mGCCsnP9qltnDf2MIQHjEfpDc+cFpIfeQHBf1LM75b3zMgEgVhInlvFDKtel3ZDx2+
	 xgoASjHChVFUhH352g6g/FvcDa8koEVcRvq2fbV8=
Message-ID: <2a980011-b229-43d4-ad9e-b3e851bff706@arm.com>
Date: Wed, 8 Apr 2026 12:01:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 00/16] arm64/mm: Enable 128 bit page table entries
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <a77b39a4-c6dd-4a8a-8ea4-2bdc31bd3601@kernel.org>
 <8d2c9ecb-ae33-42f2-a8ed-66b3286b9286@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <8d2c9ecb-ae33-42f2-a8ed-66b3286b9286@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5148EC0012
X-Stat-Signature: ocbc9mdastpdwsd9iowitr7adfjbtid4
X-Rspamd-Server: rspam06
X-HE-Tag: 1775646087-664349
X-HE-Meta: U2FsdGVkX1/6WynZlOkkWrV/R6KlFortvoaztYODF3yn4B7+CEIAVmps6YZfmsIi3oc7w86RVUv0vNv7uQy5xUA6WyQ9jiD0GcfhyuLUZSbS/aeByCmb8zOfY3DfIIzg+yciF+NEv5A8NKk9xpbaXMHXC9IyFpMxKxEt+jVhFxsxmCFK8zhNbRXIA+dVWjycY3yoHJBJNt5hOOcSMh9MOmKzHDCKkP3ZzpI1sDsPrYRFovnNEouIdNQ9k6XN0XeETKyBB89qUnTsxKUm7jqvlUhsSGq7cUt7yjLoAc04FGcSM34v9zsG7PQupTE9kweLmWK17xWamGQxkCMVcnb4oa7gDROSra1lbiiOSVFnBjEdkgzl4Besw4gg4brebHXk1WeVmfBQ4xm13bkENzfIj1fPjaon/Y6s7stxlb6/l7oeLEK+XCSHeIw+lHGSPmoeiDCRW3isyi4o2q0N+o+TAcjEQKszmUlywOa019hp815Uj1n2GYpw82PRmHpfTX8F/ju12agmiDeuTSWQN6GdjnbTurwe8HkuOZgq9ZzhsovWTbhQG/9Ho0ZF+HMIAgykTuZ8psGerF4CI6d9Do3T0AL05qz7c+oke+8rqK3dCN+d0IY1F6kApGN4qWRhS+U2A6zjXOnLugvVMpaavOYgsUdLJcfJV6H8JHYQg8RtglpTG38TElE7bPJYI8P2dcJwcZffSdNhyhn4IMoy2dTaRkHP2fwOmuB9kKWdY29JwBZJvtv22mkz24js3PpnAYn8y4qreQdtz0i6G38eKCFNtiZsOcAnDOhpdjJl9e7SN2t8NyB1tM/+u7mvFPDXbCcK+nKwsq1lp3fxPBoB+2qjmkqpFu31eT33OptLmU8r6SRirfORAU4FfVRdhafr5e43gvrBvn2CgDWPD3UssGtqHuQSXu1h50MMb2l9YIk/H61oic4wDPV22D/dvqLrB0//LIx4l22yXVC3ZUwylj4
 iDcFtWg8
 DCgzQUc7Obg3BM4Gxh1RmPYBlq4ZOvgxhZYNDAIa817S1hHL7y7DRAVJhU6KyExFyopRneaAQb8ven7vR2KtZhH8/IQ8zmQWzxnv97kC/nwNAdoluJgbScTB1+vuQitsfmglMJL/AN9byVCYj95/c3GcZWPv8fSqcNz9gabCTPYwYPCTsJ094esGviVUa3iRnYbQ29YbOr6wUN+HW7om6Yi/S810ZNHPlRTAxK8849QrKu/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/2026 11:53, Anshuman Khandual wrote:
> On 07/04/26 8:14 PM, David Hildenbrand (Arm) wrote:
>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>> FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
>>> translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
>>> So with this feature arm64 platforms could have two different translation
>>> systems, VMSAv8-64 and VMSAv9-128 could selectively be enabled.
>>>
>>> FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
>>> and virtual address range while also expanding available room for more MMU
>>> management feature bits both for HW and SW. 
>>>
>>> This series has been split into two parts. Generic MM changes followed by
>>> arm64 platform changes, finally enabling D128 with a new config ARM64_D128.
>>>
>>> READ_ONCE() on page table entries get routed via level specific pxdp_get()
>>> helpers which platforms could then override when required. These accessors
>>> on arm64 platform help in ensuring page table accesses are performed in an
>>> atomic manner while reading 128 bit page table entries.
>>>
>>> All ARM64_VA_BITS and ARM64_PA_BITS combinations for all page sizes are now
>>> supported both on D64 and D128 translation regimes. Although new 56 bits VA
>>> space is not yet supported. Similarly FEAT_D128 skip level is not supported
>>> currently.
>>>
>>> Basic page table geometry has been changed with D128 as there are now fewer
>>> entries per level. Please refer to the following table for leaf entry sizes
>>>
>>>                     D64              D128
>>> ------------------------------------------------
>>> | PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
>>> -----------------------------|-----------------|
>>> |     4K    |    2M  |  1G   |    1M  |  256M  |
>>> |    16K    |   32M  | 64G   |   16M  |   16G  |
>>> |    64K    |  512M  |  4T   |  256M  |    1T  |
>>> ------------------------------------------------
>>>
>>
>> Interesting. That means user space will have it even harder to optimize
>> for THP sizes.
>>
>> What's the effect on cont-pte? Do they still span the same number of
>> entries and there is effectively no change?
> 
> The numbers are the same for 4K base page size but will need
> some changes for 16K and 64K base page sizes. Something that
> git missed in this series, will fix it.

Really - I thought the contiguous sizes were the same for D128 as they are for
D64? What's the difference? Perhaps it's different for level 2, but for level 3,
I'm pretty sure it remains:

PAGE_SIZE	CONT_SIZE	NR_PTES		CONT_ORDER
4K		64K		16		4
16K		2M		128		7
64K		2M		32		5

Thanks,
Ryan

> 
>>
>>> From arm64 kernel features perspective KVM, KASAN and UNMAP_KERNEL_AT_EL0
>>> are currently not supported as well.
>>>
>>> Open Questions:
>>>
>>> - Do we need to support UNMAP_KERNEL_AT_EL0 with D128
>>> - Do we need to emulate traditional D64 sizes at PUD, PMD level with D128
>>
>> It would certainly make user space interaction easier. But then, user
>> space already has to consider various PMD sizes (and is better of
>> querying /sys/kernel/mm/transparent_hugepage/hpage_pmd_size instead of
>> hardcoding it). s390x, for example, also has 1M PMD size.
>>> I guess with "emulating" you mean something simple like always
>> allocating order-1 page tables that effectively have the same number of
>> page table entries?
> 
> Yeah - thought something similar.
> 
>>
>> The would be an option, but I recall that the pte_map_* infrastructure
>> currently expects that leaf page tables only ever span a single page.
>>> So it wouldn't really give us a lot of easy benefit I guess.
> 
> Right. So probably need to figure all other benefits this might
> add besides just the user space facing interactions as you have
> mentioned earlier.


