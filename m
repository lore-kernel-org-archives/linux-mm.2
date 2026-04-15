Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83001F4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA82B6B0093; Wed, 15 Apr 2026 06:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F836B0095; Wed, 15 Apr 2026 06:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D957F6B0096; Wed, 15 Apr 2026 06:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC5D36B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:38:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DCC2E3EDD
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:38:47 +0000 (UTC)
X-FDA: 84660441894.13.83861F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8381140009
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:38:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZLIyAbB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249525; a=rsa-sha256;
	cv=none;
	b=THfADEfMsXyz2RIOqSOPGBFtDcRFO8nCOpRKIewWGGI+7mBsXsYK5sj7d9h9L0d3Mc+vQf
	exajH89RWxjbPM8ndMXmPpDYhbUPpUutRVZEC1PhfC3Otwig1XVRdV2rP/Jd/yNgStqxUL
	r94aRxhpVem5Due9cA/1xSvHjJ31DsQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kZLIyAbB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzugdfaOWv0mpiqwtW8ZXjy66zEjkhjnQ3wMX2aWyrM=;
	b=n5oZ5VQ7/WtxFYJgZCKgk03kg2bOXXf9py2zOf9tAALMmiZ9wuSTZ/ghO3yoN0KZkTrWZB
	NmtZlBkpGp/vi3qRr9f+yRpPyMB9wJES87dLrJb711mtliIEY4RFNuzho37lmkKLTsbEcd
	MrXGcPp3e2ffMH1T9Hu5DziMSH6h3Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 523D2600AD;
	Wed, 15 Apr 2026 10:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB067C2BCB3;
	Wed, 15 Apr 2026 10:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249525;
	bh=qCE51tFTa1BLfSxOaRiThiT09pL3zMpL8+i20K7u+bo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kZLIyAbBtz7vnZrkuoI+3ia2GC3PxiBHPzLFHBr6Tn100ovNNWLEylPCJVT1Iboit
	 /S65KwvbpDLKyaZXwfwrDhsE1w7xFkeigtzIGZjfRs0Vp5/4vUJwJ8p0ySZHZN8JDB
	 R2EW5eskfszLPx7vY0DfArpVM/0hObfZxKzMP+5+hTxexeglU51gubR8rCDIHO5Ai9
	 aIvqSyQ9MQAvFBOiqDK4r8XNUmL48x+L/v5QNYX7Ic7w+Rp4vWPt14E8FsdudIYVmN
	 z6h5EdVg0sMQtlrBrHicjqtlhY9vANDD8vwAPuqDNlEZ2q3JJVrHvT2oF+/y+f6NYr
	 7m412mIgcOJhA==
Message-ID: <10dd6ea4-8da5-41bb-88ea-c6a4a976a6c9@kernel.org>
Date: Wed, 15 Apr 2026 12:38:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 11/16] arm64/mm: Route all pgtable atomics to central
 helpers
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-12-anshuman.khandual@arm.com>
 <aeb1972c-57ba-4f21-8289-66424e4e619b@kernel.org>
 <e5558ba2-dad6-4090-87d0-2fdec426e815@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e5558ba2-dad6-4090-87d0-2fdec426e815@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8381140009
X-Stat-Signature: nem9941mxexodgtbhh9k3ygawwwny9rz
X-Rspam-User: 
X-HE-Tag: 1776249525-683632
X-HE-Meta: U2FsdGVkX19h42cw4uXBe64AjM+APk7GIF+4/6e196DzN/9g5sEl1p3D65ix9UbE7JxDE9qejTr2LZoYV4qznsEeaglOEnVfxVhQO65shSU/Na7Fvc450ZtyUiONhe8R0GiG9YsuClMw+fmBFS+X6+zBEYIgr4xNgfvAnRRtjoRxrH/HSr9XU7TQT4T91fQIXcj+Vm2RaaVn6fihcmH+BMYqUZyP5GX8IGuZErr+KG7rgFoqvTnGMkmGpJuwnAC5AL40TA0zqipsVgRbeDzblexqhYd9evNt6dg9PxRT/cr00S2psubU8Q/BiPTce3lyGMBw2LxEOuxYkdRseSxSUV/8Bd4BqgBWluWmj18+entv/8e00tV5gJMf6N+x/UHKCTyGUHInHkbd6yKXH07Az1WyJ4gMKZAywZSLgf8Me080nk32Db7b3eofKexrDFu6tev4sW6nehCJI3Lc0tcghugShTXQvJrknNcA8YYV7VQcNz7Nxu/PQQFcu01OOu6gFn4h45hFQYIAMO6rAsZv0zgSUUdsUUJPdlfcysLAgFErr7TxRC+gdEUWkFGoOiy74hfEzEQWNsPAx+lLbFNeh6v4Cj1YYYCx2a10dF4rabfgtoVijl04cKLGt/TYKI1xjE9RoNg17nf1XoWmpvLUKPBCHx9kWsHvymxg+xvNwasn24krmrB5bO3CgF2GlA8T+GzuOUxpw0PDcruwhamsVDD3GY529Jyk4KKZ4s/6zSAaWOKQNJ3egCYS1n7mPHNBfgiL6UM4TM0yVb5MZZxk65PmCHM1JO3B/1iQX2UP1YJnhVMN++Q63xbeA5us6fkOklPB8poKJ9d9uOxabcglWEMYx4CAowZPDVGS+EFCoB9wRGJzn5mOcp9s839huE1Q/ZnXWo/nVIPexvGDCElLMy61Juhlt4xWfqzdZ8FfEjjG2i/S3CpzhIEE6tDFg2NrZz3KUiiJ6YqL10kWhG7
 uELswhWz
 CB3PyXCmAi8LbuD8KUJ99gRc0gwUlavJT/oTZsTSkjQ+X7Cj5XnIqazFsQFX+KfZQx6fsl87c596s+UkR3wN4kS8xn/aB1Fq39ljvjvTZhJBnd8XXp7jNUqDHHxZ00ieHFhOU45ST4x2hTuQLV5r/u6Q1SRhs9nqvhl6aV6Bfzc5/mA9jRsb139tSp/plJfRqZcpQqk9GzTx1a1Uf9X8Mj7NvtWxXcxjrnaodJT28e5NwzTjn4b2TwZbnhIs/8wnVv18BlX7VZJo6T9ynevDZ6DXb+mgCJJPMatiIJCxJCCch7XcSsp6dWWHm0Wt93/ZM1vee5ZM+c/3p9y1+cEhbyKSGw2Pg6dabpEfmBKC9T1e+MypaKbAhbn69XPl6PcaS4ui9SmMqPimgH97VfEDPY8NRCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 06:02, Anshuman Khandual wrote:
> On 08/04/26 5:58 PM, David Hildenbrand (Arm) wrote:
>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>> Route all cmpxchg() operations performed on various page table entries to a
>>> new ptdesc_cmpxchg_relaxed() helper. Similarly route all xchg() operations
>>> performed on page table entries to a new ptdesc_xchg_relaxed() helper.
>>>
>>> Currently these helpers just forward to the same APIs that were previously
>>> called direct, but in future we will change the routing for D128 which is
>>> too long to use the standard APIs.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h | 23 +++++++++++++++++------
>>>  arch/arm64/mm/fault.c            |  2 +-
>>>  2 files changed, 18 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index 42124d2f323d..cf69ce68f951 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>>  #define ptdesc_get(x)		READ_ONCE(x)
>>>  #define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>>>  
>>> +static inline ptdesc_t ptdesc_cmpxchg_relaxed(ptdesc_t *ptep, ptdesc_t old,
>>> +					      ptdesc_t new)
>>> +{
>>> +	return cmpxchg_relaxed(ptep, old, new);
>>> +}
>>> +
>>> +static inline ptdesc_t ptdesc_xchg_relaxed(ptdesc_t *ptep, ptdesc_t new)
>>> +{
>>> +	return xchg_relaxed(ptep, new);
>>> +}
>>> +
>>
>> We really want the rename of ptdesc_t before this change.
>>
> 
> Planning to rename ptdesc_t as ptent_t in a pre-requisite
> patch early in the series.

Good. As discussed, something that contains "pxx" might be clearer than
something that includes "pte".

-- 
Cheers,

David

