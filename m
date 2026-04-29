Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26343FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA706B00A2; Wed, 29 Apr 2026 10:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864086B00A3; Wed, 29 Apr 2026 10:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BCD6B00A4; Wed, 29 Apr 2026 10:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9356B00A2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:30:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A3B71602E3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:30:43 +0000 (UTC)
X-FDA: 84711829566.26.408BD7B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5B0F20019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:30:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="uyCgDRP/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fq1GlMG9A+Z0F92cKJJviLR+aocBdIFtc2BEmaz5G0o=;
	b=m0AWKgOGo5ONzoTiCxSznYKaTRR8xRAfEUYxet4GMT2gT4KeYGxiFu9gDhPzy24LXItknr
	wTan54AlT5xEmDNpB/JSPUVC0Rr1+j8gZDDXInkV3azw+KUUkUJb7OF9gtU/eyZN2HPOAy
	6oYckVQScLZy0FAlOWwd04wxZFulP+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473041; a=rsa-sha256;
	cv=none;
	b=lzKF9cSIO6Z9HLBJPj5Gsm+qiF6sSjfyInwWc1MpY+yyjneXqbfTsmKZl288EQ0xYGHyGD
	LdC7bCjb4goCBEL3spd+sjPmZeGnBeJK64FhIwmGEBMkPUj0MSFBh/jfsQ5OYUCIkcEiTh
	xLa+asf/aF/gxRP831u+EQXo/56c+GE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="uyCgDRP/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82B5E1BCB;
	Wed, 29 Apr 2026 07:30:34 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE18C3F62B;
	Wed, 29 Apr 2026 07:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777473040; bh=yYUcrffafPaOm77R9dKuGdogYVbwK0I1WaJfySVSriM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uyCgDRP/abTLDH1GF4bhkMX0G6Uck4hgIgyUBRuXB/drSr9g4g9bKGm5viIR9oygl
	 cP56E8UqUoyxELCQIEk1OYF0wK9VrLrDWxYYc+nMmpWw8waMr9WI7BvBrp4N2WqRfM
	 sg1QsRk3kKCYoyYwdAkATJHWTz8jmDVV0zK0xhLo=
Message-ID: <2f5692d7-6589-4717-8258-f43d8227d74a@arm.com>
Date: Wed, 29 Apr 2026 16:30:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/15] arm64: mm: Don't abuse memblock NOMAP to check
 for overlaps
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-28-ardb+git@google.com>
 <8a315ca2-3754-4a66-990e-55b85191aa6e@arm.com>
 <1f9c1ca5-c15c-4a08-aa8c-cbe64f7f205b@app.fastmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <1f9c1ca5-c15c-4a08-aa8c-cbe64f7f205b@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5B0F20019
X-Stat-Signature: xm1q3erkubfonyw6u57rt74jm7pc4k17
X-Rspam-User: 
X-HE-Tag: 1777473040-739456
X-HE-Meta: U2FsdGVkX1/8a45TlfLTzL73zLtZK4Qyz5AvRP99zAqqBAKR3Fn0U6/bArMc/AwMCVyOTYxTV0oGYZIYEkahj71qBASUTyZ4101pXZE8X/x85mRgip4uobALHKl+JDHmig2BxKUtx3BvBNLb0+TMQSM7MZ1Pyh0xkRSwgjnf8Y0H4ch8/Rf/fjuFgg0YKsA3nBqhHkWyqJ007SH9kkBmZq7QTd0fXMXuPxo9rkptfe+s5WjV3nN8CObiL1ZNWZ12aaPLOj4yKuGXknO8GPf+ZCEWd5TdiqTwDzHYBDE3Ltk5Qsw1RfEOTVM0nel5RLa8iUpJSzHj1SuOmtVf07U0ElSpAp974XFxNZVYKNgfL5C25U02LCjyX5FvhjYwV6+ouzBXSmyiSKSdr14IgE4IVypbKZiHYC+8RnvJ4/8dx+bcKubxfIwoU0sSba0FmcJ94RSgAVk7eMlD+MzK8B1IhNi7sgMfiu5OsDTnYeKDSVlUxkxgLFd3SUBqk6BfRNY+PClKvSqu0ZOV/C6KMRrAKecOfytknoBM+Paw6ZEpQsamOkfDfJzyrzdrac9xOU80E3uTvJ2F/+fjRTrJD4URCXkueP906ahMmLa4eQpTjd3ubp2e368ynLbXHGorT93P5OiRaxZX4jOo/LhIkvV4TTRwyLUC0kFe2tyfAunPARatBSuccer6OWKY6obumWPD6GqaC7HQ2B33n2lPQCfOP1AvP1Q1+aYvugodqKRlOI2MqTKl0PDDWd71NvNFBiyN6wLGLjYHyDKgbTLaKsS2TXSjp+S0UyKyTo66mRZnrz5QRvnEmlDJOFbjnJqvrboGjkBjDhyo3KmhOh13HYC0JjpxpycLj7roDWobb0NAqzVu3Rk7uuUsXUYb3NCJMw86G2nCnvG4AumrahzcN77y9Q1QENJyXTZmqVTd/zeExtTU961QrQkROm0u5jqh86doCepNzud7ACcXEiEclIG
 q5Qe4U5H
 sPCttdTEEqb9xXJnZhagE/ZRiShJFPZQIiINTh7ZriPiM7TVT+YquU3Rfu5kQJ7Muk9JeureDA4YDmayzgdpzwW81yddVEHMNKU2DQ1Y1/d9fcvlY4OwH+K6S+cfHz/AZCKgs83J/uR9Aoes00KQTKXu6adUO2cB3tcMihCJFwckoCbn3L05992nYnnY2WJjP1yu00whGMpiDNmfKqD6+/exeo/W4u7ITx+W3Jau5rz1c1DsD43I12Lt6algQVgDyfCy/o8G4mqQQ72VciLPQwj5V5pzbkXs7kzr0ZuTvgIhO+S5xDNpFEiP1BuYDBo2I6nciJvxJq4AAOqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/04/2026 16:23, Ard Biesheuvel wrote:
> On Wed, 29 Apr 2026, at 12:54, Kevin Brodsky wrote:
>> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> Now that the DRAM mapping routines respect existing table mappings and
>>> contiguous block and page mappings, it is no longer needed to fiddle
>>> with the memblock tables to set and clear the NOMAP attribute in order
>>> to omit text and rodata when creating the linear map.
>>>
>>> Instead, map the kernel text and rodata alias first with the desired
>>> attributes, so that they will not be remapped later with different
>>> attributes when mapping the memblocks.
>>>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>  arch/arm64/mm/mmu.c | 24 +++++++-------------
>>>  1 file changed, 8 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index 5e2348b15783..1a4b4337d29a 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -1148,12 +1148,15 @@ static void __init map_mem(void)
>>>  		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>>>  
>>>  	/*
>>> -	 * Take care not to create a writable alias for the
>>> -	 * read-only text and rodata sections of the kernel image.
>>> -	 * So temporarily mark them as NOMAP to skip mappings in
>>> -	 * the following for-loop
>>> +	 * Map the linear alias of the [_text, __init_begin) interval
>>> +	 * as non-executable now, and remove the write permission in
>>> +	 * mark_linear_text_alias_ro() above (which will be called after
>>> +	 * alternative patching has completed). This makes the contents
>>> +	 * of the region accessible to subsystems such as hibernate,
>>> +	 * but protects it from inadvertent modification or execution.
>>>  	 */
>>> -	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
>>> +	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
>> Is it now necessary for that mapping to be tagged? If so, it should
>> probably be called out in the commit message.
>>
> As you've pointed out, the initial r/w mapping of the linear alias of rodata
> will need to be mapped tagged before moving the zero page there. So this patch
> will just preserve that, rather than remapping the region tagged explicitly as
> it does now.

Right! I got lost in all the mappings :)

- Kevin

