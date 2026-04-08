Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFAA1073C95
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4811E6B0089; Wed,  8 Apr 2026 06:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431EE6B008A; Wed,  8 Apr 2026 06:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320A86B008C; Wed,  8 Apr 2026 06:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0306B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:53:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0FC0BC62F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:53:34 +0000 (UTC)
X-FDA: 84635077548.06.99C6EE2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E804A4000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:53:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YAzqbbD6;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775645613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUNrqRez1mI7xtLuIZsNGGc0rl8SPMNPJLOT62oVBX4=;
	b=HTh3EkmHVEi1BN+Ll5j923tmEwzLkb4qaWgDhgyQrZQhcLL3ssCvKYThhoO6i4UFoey3BF
	+sATpAXZI/p6bYdtlt7Q6RlFepElDAUon4U0K0TXRTu8T6+YiNQfD+eejs0UMjI83fIxWN
	TrujSsrNR5KLfbtTMeJQostE0YfvcjQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YAzqbbD6;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775645613; a=rsa-sha256;
	cv=none;
	b=pMz6GaDNjJduwe4SxagOgfCNDP8bF0fG4Pe7dCctcOsPBuVdvP7T/x1n9rHqOWVLucKrHS
	Y3vpalP7P+CPY7AIhw8AaOEnIOY0Uxr2tbcjKis7aoFs1Jd8hzRpsahNbeY9D7CpevU2Fr
	9pNUM2GmXbYdYbbZIN212jRS7VD+duM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5ADEF3161;
	Wed,  8 Apr 2026 03:53:26 -0700 (PDT)
Received: from [10.163.180.198] (unknown [10.163.180.198])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DA693F632;
	Wed,  8 Apr 2026 03:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775645612; bh=MPK0uYb/EHnrGdeWKTK12aNHXPiot59i8+gKdz4eK5E=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=YAzqbbD6rwBcRRfg260pPT5lpSpovV2NVf9BEx8C84Wg8nzCbk6ChXUm88R+CX/4R
	 0F/1adsXW46SjtD+FRaBG1UjN9+Q2dQhSbIZIv3hkTe4ZeGxMWkrZPZUkRiof5QbsB
	 Vu9+UyLcd/BvjSq//RRJ/N7UmKXhIpkVAWXTwL5s=
Message-ID: <8d2c9ecb-ae33-42f2-a8ed-66b3286b9286@arm.com>
Date: Wed, 8 Apr 2026 16:23:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
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
Content-Language: en-US
In-Reply-To: <a77b39a4-c6dd-4a8a-8ea4-2bdc31bd3601@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E804A4000A
X-Stat-Signature: 7skgcbyp4i97obuhkxm3iz7kn1549s15
X-Rspamd-Server: rspam06
X-HE-Tag: 1775645612-606223
X-HE-Meta: U2FsdGVkX19Z/f+vCpqbaXwiPPqJUxuZ/DAcxwFNGkJ+d9qB8W1uMDNV07qCRTzvi7NkwG3IC8Dco0jO4PUBr6tFdo1htQuL1qepaxrYL9LYDXs81VaZkpp/8BYJR8PXpyj+e3YTnrzwpWJ5j3+TlAoXSdsxFXL5sfKtiiey4VjgyNvkhJcIisqDXX4jow1HS//rQYrd8ksI/OG7ifzv3RK/NgSifqO5DVR9mnKxff/TLb0fPv8pnm/1v3w66DPtE2aD3iTkTdnng9JQW5bwMXKwJCKsrfNfftrA7syhCArAfQg5yot0bqKO4RJIWw5ly63XY4J3s9lixeQOgj/XXdY8arzDjs9zZIlICycHAYM6wW65On8jPY2AfoeChxM7pbUH3Nu2cwywRIB+0ARxwazWckTVeMUhP2LJeHlSS8RWRCiEU8sp/C+FyiJPkav1wcfyulL0WEN8bruoIyBehm4UFIHrLNj7A1KlgbXbtb0LDraOcAremyerUdzkq8jP4nbqzLJe5xLZTxcX/m6lOoL7QknFT1KUf6HFTx5CT3f4TEeZNyRC37AkPIiE0cBu+lkEgvO1wQYMb6tTZVpYy2ZlZyit+51Lcc7ZdT7gCQBS8OE2XcnxhQFUX6pzRfCwZ9ek3XK6N/YgYUJ55xLLZKsGVRRnbqEN3y34sMTl1PyVYZz6fFFFSHM8fl3tQHlwHHWB2TDum0pyT80ULxFcM82KCf8Gop6lYGJVadSrwIMhWFUDvlAPrsvAL283rSOP1vFntRv/xGz34WmUdLdLa43Er2iiEi2J0qSWDgCgZVjbs/mB++vWD7oGLIr2DpFxnJsmGpEnjka8aYd8KbEirINys0SyCkujjn80UhZepwi5WmCa7ob9jtFK9/HlwNNzGAhnNzO9dLbi6xUD1VLVth4gtuIN3MQqmW6F+drNbwYxJgs8MFo/C2fP6QBYvhB7ou1gkNiPKGWxB2x3Iee
 XJ1el5gA
 1O3wsVUB7oGzL7pWE3c1AgICBVRS7/3BYse+Dddt/ozxd2h6tm27pk5g8zmKWlRWAUA6o/j4xfyX8qpEfN15V5cnqGp2oxeAweFSkxV7djEi+llaNh2YpqK1cx0U1+YSGNEwhkwRjMfXukOznZ0CgKsp5fDalv24iJVymRGkjoG3ILPz6kxpBFiGA+U5YxQOvF00GhH187+PhzveCFtr8UL05YEp1IhyTQtovgV2z4/dZ/mI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/04/26 8:14 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
>> translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
>> So with this feature arm64 platforms could have two different translation
>> systems, VMSAv8-64 and VMSAv9-128 could selectively be enabled.
>>
>> FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
>> and virtual address range while also expanding available room for more MMU
>> management feature bits both for HW and SW. 
>>
>> This series has been split into two parts. Generic MM changes followed by
>> arm64 platform changes, finally enabling D128 with a new config ARM64_D128.
>>
>> READ_ONCE() on page table entries get routed via level specific pxdp_get()
>> helpers which platforms could then override when required. These accessors
>> on arm64 platform help in ensuring page table accesses are performed in an
>> atomic manner while reading 128 bit page table entries.
>>
>> All ARM64_VA_BITS and ARM64_PA_BITS combinations for all page sizes are now
>> supported both on D64 and D128 translation regimes. Although new 56 bits VA
>> space is not yet supported. Similarly FEAT_D128 skip level is not supported
>> currently.
>>
>> Basic page table geometry has been changed with D128 as there are now fewer
>> entries per level. Please refer to the following table for leaf entry sizes
>>
>>                     D64              D128
>> ------------------------------------------------
>> | PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
>> -----------------------------|-----------------|
>> |     4K    |    2M  |  1G   |    1M  |  256M  |
>> |    16K    |   32M  | 64G   |   16M  |   16G  |
>> |    64K    |  512M  |  4T   |  256M  |    1T  |
>> ------------------------------------------------
>>
> 
> Interesting. That means user space will have it even harder to optimize
> for THP sizes.
> 
> What's the effect on cont-pte? Do they still span the same number of
> entries and there is effectively no change?

The numbers are the same for 4K base page size but will need
some changes for 16K and 64K base page sizes. Something that
git missed in this series, will fix it.

> 
>> From arm64 kernel features perspective KVM, KASAN and UNMAP_KERNEL_AT_EL0
>> are currently not supported as well.
>>
>> Open Questions:
>>
>> - Do we need to support UNMAP_KERNEL_AT_EL0 with D128
>> - Do we need to emulate traditional D64 sizes at PUD, PMD level with D128
> 
> It would certainly make user space interaction easier. But then, user
> space already has to consider various PMD sizes (and is better of
> querying /sys/kernel/mm/transparent_hugepage/hpage_pmd_size instead of
> hardcoding it). s390x, for example, also has 1M PMD size.
> > I guess with "emulating" you mean something simple like always
> allocating order-1 page tables that effectively have the same number of
> page table entries?

Yeah - thought something similar.

> 
> The would be an option, but I recall that the pte_map_* infrastructure
> currently expects that leaf page tables only ever span a single page.
> > So it wouldn't really give us a lot of easy benefit I guess.

Right. So probably need to figure all other benefits this might
add besides just the user space facing interactions as you have
mentioned earlier.

