Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B39B71073CA3
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B976B008A; Wed,  8 Apr 2026 08:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC5A6B008C; Wed,  8 Apr 2026 08:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB466B0092; Wed,  8 Apr 2026 08:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9D5B6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:13:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F4B31B9073
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:13:45 +0000 (UTC)
X-FDA: 84635279610.29.DA72172
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 617D2A0013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:13:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fm4pYk+i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775650423; a=rsa-sha256;
	cv=none;
	b=LJat+gM0jqr6mmsFRs3tbR+SdGSLkqtOI4iGPJueQxmpwg/GolnWjU3EPcIAFfDfVsMn5q
	vOjzGMZYmx5Xk7GNpDUn6yi+ytErHYKZe3dDu/psKbh9jM2iFcVfTDVfR3Fk73zjiqU6vg
	pivtX25xSfuqlbBWR/9A/z4b9g/IEFc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fm4pYk+i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775650423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5ScxPBx0kg7ANwrTp5zjzec2BzFmHNH/iCqb6c5JzU=;
	b=t7ZcFodzL0yHMEb3hNzZEaxmw+CGhCvaCY/8c5t9wfye0GkZmTI9xlITIhORcxc7LvPkqV
	CpiYgIlqptTMmi1Befc7HZhStlp1yijaEyzCCh+54nPYOV9RWJHtX12cOx8bOX5AuaSycn
	u9k2jicRi7NzFaw257uUGe5v1w4j70k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E54E40521;
	Wed,  8 Apr 2026 12:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26D2C19424;
	Wed,  8 Apr 2026 12:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775650422;
	bh=My9ex2aNfAQr85RMj/PNNceXRhuE1pGC/rvjjhvlKho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fm4pYk+i6DilsXsT+t8GY4iXYWcW035fNURZeBfTqXB9B2RHLiHuFxqigp1rueLf2
	 IGKW4LWsJv2ucGAUoKuh2azO8SS5Wre66FjKiCABx/HucXfyegCmGc9lzI6vXZm9TK
	 IRIn/uNZIhUCkHmI5GvnB0izbKU55WHY8/qhSYDgLF+SJ/S2EgfLoWg9Cy++NZmfVV
	 zBhwO2uVX1GHHK9yz42oCR5YFqm6oBIxDibRsv1V8zutdmVYIKkkil68x+IhfAdKQ3
	 G2j6eq6FwzrPCG9IfEdd/fZKO+YrDfABRPtn4RywDcud+oDOGYsONZgdcI5cfhD47D
	 KWN2m7RrTEYHg==
Message-ID: <c664368c-fe2c-42d8-b488-e9e30b342491@kernel.org>
Date: Wed, 8 Apr 2026 14:13:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 00/16] arm64/mm: Enable 128 bit page table entries
To: Anshuman Khandual <anshuman.khandual@arm.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8d2c9ecb-ae33-42f2-a8ed-66b3286b9286@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 617D2A0013
X-Stat-Signature: 5rub1xhyzd1pdjhdukptpshiuanh667k
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775650423-57731
X-HE-Meta: U2FsdGVkX1/BGA3SdK0s+SbYGREqh81OKXpXJV1MisqsJ14JnJ9RpvsQbVNivbxlRF0tHsB/wbCOKN8HhC+4p0Ad37A9Nmtd2iTQdB5GT7MMjQrfwf+4cmNUyKkJjhJCVYmWvVn1oX50yNvzOIxBRzPM8lFrZ3xvfdn5ttcQRpvH8fcqkL9d/9n6oDS3Yyq78RAE3HhyXSfFbdFVfn9S5vkBg2XZ0iZHsoU0HTgkDtxCMb+boQIyIm8tT9LGc7apQNw1aEthp/ruYNJzBZLXya6y9fmHrjhRXRQIyaJsZBEhAndFQBn++9G7kxg4XqkwgDOJv/q3ahgiS6RUNjAMCB3ppTNqlDLnDIMrrmrKD4HIiknlNVzrYclxugi4vqUEq5iZ1a3YQnVtsUxe2di+Iw++WNXZ1BpZGqT2pAUWRm0E32WdhGylJQBGei8Lnd4zpMp+mF+U63+6G6rOMt+rT2V+Gq0e1n8FMl0vPmObTmNnf5ghkenHhTuOxDymcMIXod0BmqYdHBEbO1WGoPoCVQWHXCbe1TkJgApdDtQny60UGqhzaSY+kRtfKRUmFNTrnpeNNixLAryYrDmfRl9752HoypRgbfUYdKW0Sq5t553jYXiLFH3UtbODoOmJWAMg9pJ7AqE0bjT1KeKrNNFLaMPEagwby7uY0eDzZetuoPjCBQkrcDbB/NfuSsW6rC/2F5OVOCWCZq2oM9O3oYAXF9ROP7rRTskZJt7T55yXYYFkDXQM1J8ocnQi1FTodFUpjUmBJaItAD14vyYH0w3tOjjGy/K0ObUDGGOyXKxcqpsRe6xQ5AgMghG32eWLIsEUm3O6+eovSVBBKslJ/AEoNulGxg8s9ou1Qse7zskdf9MDFrtf6Q8e+95gfDHV7tDHNaAj0txSGzwRNznQZ6BfjXOCx+BMDcKNEVCcd4XqjgzIR9kB1iM6OmAMCEI7eMhDYlBOFDXF9PPZm4XJkR8
 OFCLqNDb
 fydEVthcaJWpmb/jfHNpCu0mevCtkgSoiCvDZn82E+c55aXhuDoEzuuK66/cdX9cMNBMJUEeA7kxe34+GenBgDmI0kYa6XAV+ohTc6Kp3j3l6GlFqx2c5DoSAnTLdAM0BKmyIJNs8OnUB1u/286xpO3vLX7CgEJh0oj31zNvwyqCrXi5sKLoKh/KIAXXV60EIo3v39WuCBiGWEOJUexENSVn/Jhu+yGhd9lY5YnB/mpG6QmWyNl/BAe0idD+9xctOj7v3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 12:53, Anshuman Khandual wrote:
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

Oh, and it would be great to also clearly spell out the effect on
hugetlb as well. I assume the available hugetlb sizes will change as well.

-- 
Cheers,

David

