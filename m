Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FDF1073CA5
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13576B0088; Wed,  8 Apr 2026 08:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3D36B0089; Wed,  8 Apr 2026 08:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA346B008A; Wed,  8 Apr 2026 08:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76AD96B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:25:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 182E2C328D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:25:25 +0000 (UTC)
X-FDA: 84635309010.14.33956F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C43DC000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:25:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qAjG9wWK;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sO90AtWIAArw58yjhcEPrra87St3zi5zPRjX3hB3+Co=;
	b=7TnAaaUJwjV+FygeTntN6MWu73Me8yMQNeFAIrflCB1lZvQ4zG0KHaRm6Deovjxc3vtjy0
	tTFcQCMlb+SK4er+mtJeoJ0KUs17hNmxwBY/I2vtVIIuwdIMXmJYfazs6msuHtdwZ0B++o
	aLagGoYefTYEidE6maw0pMzHGCpndMw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qAjG9wWK;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775651123; a=rsa-sha256;
	cv=none;
	b=J2bQxHoFaAFaUGsgHp9ptg4jKUcoufaSraM4scG3Jhpl+8ehYXXeqris7Cp321gCS1pd/L
	qQjrYusHTr+Td5JARECR0nWplMlWu6cyQH/3gvp8Xitmt2AQk7dCP4N/XAAQareP6L8xvr
	re59wh2sSFjvagjg7sKHz9KRPUhZRI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 87DFE60121;
	Wed,  8 Apr 2026 12:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FD0C19421;
	Wed,  8 Apr 2026 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775651122;
	bh=5kwYf8VF5h+Jca2gaUoEsSCMqtEUj3juDowD7LEL0Po=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qAjG9wWKFtPV9NXS9taO6Yiy5MUnivAviihZaL24nX9D+axPsZSFyrVpkQFN5UGQN
	 XFNoNSbmAcl8c7IH6DY9o3YnBFOc1Dw22mQSoVgdN9mecPwWH3AV0keCj7KBxCEbWf
	 wBgOzIj8VSVBkIKI4MWntYqvHpS+aS4NlAHiwXO255mFXwlzKlPKOZBCkJEUX5qSQ6
	 tk5sehdDv4tqFgxADq73ZIuMNZrKPe+imDA/E1WLDZmrt8jFrHUZfDWOiWV4YWKVuD
	 Epa/nui8dHaQDCQjXt8a2eMuAC/Gy18XDVfh2KqohuQL+QfGWzgbTqfjBeTz4NUZbm
	 vwnEe//dG767w==
Message-ID: <1a1cc83b-5b2a-44cc-b9e2-a31dff7ff887@kernel.org>
Date: Wed, 8 Apr 2026 14:25:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 09/16] arm64/mm: Route all pgtable reads via ptdesc_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-10-anshuman.khandual@arm.com>
 <aaLO3yOu1ShO2tNz@kernel.org> <7f7130d0-f348-451e-960e-b7e6ae9c9ee7@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7f7130d0-f348-451e-960e-b7e6ae9c9ee7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C43DC000A
X-Stat-Signature: 9p5smzunmx5kuh3r1npmeq73r8yo6efk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775651123-6426
X-HE-Meta: U2FsdGVkX1/lLisgHkz7vZq/wCT9pg0HzmKC1P2DuxGP67VknQYmoiice4l+lTDaxIdseththKUXxyh+3ktLK9fHB3Q9Adr754dxcDUzJ7io6xScjwmgv0V83BIoCHIREucbfRZOgyquaH3C9DUkbiLWGkPV5tL3M69Bg2zGUrkJxCyOmr9XgrR9Dz/3IQ3H5BB69Z0QhIRhvmglFCPaVqe/+1eWBBSlRKxFht5m3XYuMMjjYvwr5YaGTyodf3KAkwyLAkljA/5tpWey5fn7d3Fy5x9GTRZtevemm/Y9KqY+rWRISiOuh+nmsOVOJNVmBPKMIN0Ap3ze0ICEE4GkXoxyjvYEKGydqdtblP6puPLpAMDKZkngYy5cB9Q4qa2olkSgW7m1SqBwgnaRGQD4qD3kq1Z4no2rSdHFCMSVNK500O9CV9v0HPvshVPtCj5tYjW12Ahnz2Bka4UXlILgZYZ7Fm8cg+DESminUjscdxc2AhG3LsLfKH1WHMAvCB7K4HMIEQ4/uf+nE3HUTWuXTgDePDUqugt8o2Hf3nE5zylMyiTX2kdtNtYSKXKncTgrBv5wDo2jvz8pHvPQIGRDWBD9l4Iz95e0WWQ8CAvq/7IIpMqtYOTzeQvrSjrQuypSd5U5ACD3eSHBEn2dumOFyqyTN89N8/WnH8dqw/YoRKgDuGMAxrWojAvHcWOXB5o/8MYFDWMlmy5wRUJNkg5wNubtUK3uClwP/y5YHOM28j1h9dYgPirZAyCtFEEkNGwVaVz7LWfpaRZeMpuXMz0hYf0EgXuQLILZsRUkyoKFupcus+Lc0P4dftWr0E3gyggZFF7oRZMsDgKWhfPgaUa8Bsrf1huPqUwBICkPwPBGWeteiNpjPSWFnz7aKhA7harAvbgRRj2wPOhNR6mxGse17s3UGohBWAQqYAPmwBIRgE4YmWKyrYnD9ZN1d53+SGcPzN1YECoCILQRdVd9TIY
 k01rceRC
 LFG3dyy2lF5xZAnL+K4asvSN94fDWlqrfCtCt06hT2lWQuWtNABtumZhdejK6j6nsEOnGi9VqFzRqwCAZpSF8b5lUFj7VElC78DmccgmBGqtBqNY/4FjnPAJ0FzpRK30dAiwKL5HeqQIXIQtmliCp0FOUcAOBLCnvGE7BOgVYO40x2Qkaq+gAS8hmN/ggxz9tKG2N8/CuuGIAGfey+giahWClChmB74W2jx7aDkX7bNV5ZS2hfkTv2+Ume2zQEY3nZz6A0PDA0vkMLrELHw84Hlh4OmXZWG3UgczW88UzYo+81YHj7TA0Ndfg61BoI29pe9i3ItDrAu4DTGhybxie9nJLEZeJuR28cQKQN+1VlflxI2Cu5Z3WsfVfwxY+4U5lKhkQQ4SQbRRKK6BbUc3nl7CUmKVf1DJ441JnZYHcQ3lMvW1gAiFijWm9ItiP+n7FAi6q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 05:34, Anshuman Khandual wrote:
> 
> 
> On 28/02/26 4:47 PM, Mike Rapoport wrote:
>> Hi Anshuman,
>>
>> On Tue, Feb 24, 2026 at 10:41:46AM +0530, Anshuman Khandual wrote:
>>> Define arm64 platform specific implementations for new pXdp_get() helpers.
>>> These resolve into READ_ONCE(), thus ensuring required single copy atomic
>>> semantics for the page table entry reads.
>>>
>>> In future this infrastructure can be used for D128 to maintain single copy
>>> atomicity semantics with inline asm blocks.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h | 28 +++++++++++++++++++++++++++-
>>>  1 file changed, 27 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 257af1c3015d..804ef49aea88 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>>  	arch_flush_lazy_mmu_mode();
>>>  }
>>>  
>>> +#define ptdesc_get(x)		READ_ONCE(x)
>>
>> This will be confusing with 'struct ptdesc' APIs, maybe ptent_get()?
> 
> Created 'ptdesc_t' earlier on arm64 platform as an unified data type, which could
> represent page table entries including their protection fields and masks for any
> level.
> 
> typedef u64 ptdesc_t;
> 
> typedef ptdesc_t pteval_t;
> typedef ptdesc_t pmdval_t;
> typedef ptdesc_t pudval_t;
> typedef ptdesc_t p4dval_t;
> typedef ptdesc_t pgdval_t;
> 
> But now it conflicts with generic 'struct ptdesc'. Agreed that overall renaming is
> required. Probably ptent_t along with ptent_get/set() could be an option. But that
> is probably orthogonal to the series and can be done later in a separate patch.

We often refer to *ptep as ptent. Can we find something that does not
contain "pte" to avoid confusion with pteval_t ?

We often refer to the set of functions as "pXX" or "pxx". pxxval_t would
certainly be an option, but it would be the first "official" such
occurrence.

-- 
Cheers,

David

