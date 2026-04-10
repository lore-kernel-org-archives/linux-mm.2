Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3367AF36BA9
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B42D6B0005; Fri, 10 Apr 2026 00:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365236B0089; Fri, 10 Apr 2026 00:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27ACC6B008A; Fri, 10 Apr 2026 00:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6756B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:02:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBA60C18E6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:02:32 +0000 (UTC)
X-FDA: 84641299344.02.1B3E4B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18447C0002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:02:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dBYFArVv;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775793751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9hZBB7Gf9kFgeqsM8opn55Bd+NuUJf4xQRMbeQ827c=;
	b=Li6jJIAPYpYu3ZrnZYxqqjYXY1ABeP6Kt1OEhDhUHe3Q6m3ionCx6NqrbX6xVx/6gMSv/y
	fUb/tDndyR5ZDLg3TktPnS9cFMfiAUz0a5BOpV+vJK2FPT1euKz0lhVelAtdz4vIlQuKbH
	Z4GoFYDLZCsA/P5phbpTWcV3If05bvQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dBYFArVv;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775793751; a=rsa-sha256;
	cv=none;
	b=sZPrLX2PsHEVOtwPKfe1ahd6pM4BLyvH7xYzGGutVH1xIwuZolNh3lY2u5FdQtgh0G2Yas
	5yBZXO10X7YG430dZcfrws7nTDKsDMMID2mJGr0ledWsBHld1fkRm4cFZzZiFv3zvVX/HK
	twAp9PZVa2Flhh0FxttFoqxjX4wZ18w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49A711D13;
	Thu,  9 Apr 2026 21:02:24 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 114033F641;
	Thu,  9 Apr 2026 21:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775793750; bh=SRztj8vW9IVfsNnDlWMXIQNZpY38AX6pQu/yOpn9X3Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dBYFArVv8DgQwTOhXcFrq5eacok3vrOckMgsfIeMP9E8+Tx8IlH/rbYfzpCQF7qxn
	 PrRVggjNP3h4nPwyft1ja8QH3WU2XnQJAXZWL+PfFMYFvgb7y6FMa2zRPKmMBCidc7
	 YW34P13UUVFhVmphad8ixLXOBqfVXQfHTsdBxjKA=
Message-ID: <e5558ba2-dad6-4090-87d0-2fdec426e815@arm.com>
Date: Fri, 10 Apr 2026 09:32:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 11/16] arm64/mm: Route all pgtable atomics to central
 helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aeb1972c-57ba-4f21-8289-66424e4e619b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 18447C0002
X-Stat-Signature: 8fct36rmsetzjo4z6wrgduppqfd5jgmz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775793750-682562
X-HE-Meta: U2FsdGVkX1+qRJyhrf8zgcPiD/mKNIVLIWEDA9jyYpfUgjBNxNfvc2mcOnoavjiH/0wFYezHKa876WibtAkWeqeIU/NNtvQhO0gfZkUSypulswVUR4THFXcdTC1oKV1iukDj3Ao5jghB59FIZUX/SGCGHdyPImcpizvJWhOXMpwr6HWrbA4lz8bgoTkiqAvY7nMsMa8P/L2bVBMVwgpUbZelPYByRho5ZTxnXzrCmMx9cMlyhM5Vs6mB5hzdsSkjuO587RWzOJUrlYR9Ih5HTf8LEyqd4IRVw4RQH2GPIZQQHfmmraherb7ppmeHSQ6bQbjKCte5iMhf/HMdJfw/n+Vzjr9+EtFXGJtj6YLCXVN81NizHIYCeC7KRRKAC0AcSGaQ8231Ykc6t88ST8XSeg8BFraPSz8AxNAyXfL2kN5EUUAY9v7/NIC/3BzD1zaURBp7JqmZ7/LMfI4bdYTf4gyjmnRfxudoFbAvXISZEr+Ad2RyyNNHfs3JEu/HuAYu+FgXC8yUH+X12lSPoPzlHH9xW/DtnXmTdEBfKONdU0daKLuoRWxBx96XtXH7slnjposQn5puDl9dd7+7nfKGvW8O+9Xa4RhwPHcb+cr8TvlxzFwqJWtVjpOHfyDXs0XEU2nf5zH7FSaS9Rs0Xc+v7Nb1yrhsFGxsLYtNr32lDSieBmMcF536u+ssaTzTPDHgr9NZ0M/eCNwZZ5rycJzKDnzO0BpckHFRKmBShxBtNyKeHPK75nJ0Y3i8vYFNqvXbK8MzcuJYQs0iuuxoml3l/3RqMykxVCAYB2ecPif+/kF9V79mw0hr0qqQ4bG6fGc0fgncpx+Jlk1w5hkAnKI1xEXngBH5WbukNaxdBMY9/fm/mQK/4jAB9fHxRxtSajaIKpwt37vc2SfeYSO42QrXVmAXJgNL2TN1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 5:58 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> Route all cmpxchg() operations performed on various page table entries to a
>> new ptdesc_cmpxchg_relaxed() helper. Similarly route all xchg() operations
>> performed on page table entries to a new ptdesc_xchg_relaxed() helper.
>>
>> Currently these helpers just forward to the same APIs that were previously
>> called direct, but in future we will change the routing for D128 which is
>> too long to use the standard APIs.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 23 +++++++++++++++++------
>>  arch/arm64/mm/fault.c            |  2 +-
>>  2 files changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 42124d2f323d..cf69ce68f951 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
>>  #define ptdesc_get(x)		READ_ONCE(x)
>>  #define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>>  
>> +static inline ptdesc_t ptdesc_cmpxchg_relaxed(ptdesc_t *ptep, ptdesc_t old,
>> +					      ptdesc_t new)
>> +{
>> +	return cmpxchg_relaxed(ptep, old, new);
>> +}
>> +
>> +static inline ptdesc_t ptdesc_xchg_relaxed(ptdesc_t *ptep, ptdesc_t new)
>> +{
>> +	return xchg_relaxed(ptep, new);
>> +}
>> +
> 
> We really want the rename of ptdesc_t before this change.
> 

Planning to rename ptdesc_t as ptent_t in a pre-requisite
patch early in the series.


