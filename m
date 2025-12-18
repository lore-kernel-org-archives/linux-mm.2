Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B7FD6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A15B6B0088; Thu, 18 Dec 2025 08:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B366B0089; Thu, 18 Dec 2025 08:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E196B008A; Thu, 18 Dec 2025 08:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72CDE6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:09:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40A2016015D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:09:02 +0000 (UTC)
X-FDA: 84232622124.24.445BCA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 62A464000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:09:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dlaanNU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063340; a=rsa-sha256;
	cv=none;
	b=kurl+taBD9Eq8JAjluwCEDDJM6lJexJ0uKyS6tP04TpTHUT0ZmM9kiFgLa6AVPMKS3YgQo
	aTIKBYVAPXTqgw2YF7PSzIZfZrpatIxo8IF5o2Bjjc0cePPDBZ10hvixsui0aJdbw+pRbV
	wNeXoyOymtl9832fbcHYvMDF1TgwNG0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dlaanNU4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mniP1/O382c7XL2NrEy9yFTG0ffhAX3e3CPErT81yEA=;
	b=pl5hTRGkY9FaaE+FHcpxzIkYOBQZrY7iBmk5UB6bTa0Y6p2dmRY+R8dxYVeDN/oWbQbJfL
	18PJO/ujggAeN43UTOXYw4llXigQ+jg/ezkamJyhm1SyvXQ4oMBJ/B/LFj/b0g4+1vpA3g
	zC/+Tz82xEER+MY8eRBqTvmTEv48dUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A2254057C;
	Thu, 18 Dec 2025 13:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752E7C4CEFB;
	Thu, 18 Dec 2025 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766063339;
	bh=0f+h7b+YOWMHTpqkys0NZVUgtFkd09ljBQAIIb8BYlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dlaanNU4XaeqJ6Fw+l7gb5R9fj9XzIwLPvYylFyMeZ+86+59Awhj7gokVCe5AjXID
	 VEWPNJXh6WRvrO8u3H4K/6ADHyYO3We4dmJnxSxy6XsmRJ8KXyoOK639E+Pwi1aDc3
	 KrQ4vqhF2wBmINiPTRty5fkKmB01SqIP2dXkaTAsC/pX295oT77A/o1lmqe2HwDY41
	 2Q0K3/PDdNFZpPGQ5XrPq+y4/cXCCHZK0cIbqvMifDYWC/vHKaxAUIo5GsAlGWgmHt
	 p0ILzG7u0juBycR0B0nxf58poGQP8StDWHw8xmZYxlmM4X4tcgA35NGdgwFPH6qQqW
	 hEUz/JDYJtFVw==
Message-ID: <f7552c2e-e12c-47c8-9b60-ec645cddf804@kernel.org>
Date: Thu, 18 Dec 2025 14:08:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/3] mm/tlb: allow architectures to skip redundant TLB
 sync IPIs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251213080038.10917-1-lance.yang@linux.dev>
 <20251213080038.10917-2-lance.yang@linux.dev>
 <4ff8abad-186a-41b7-a269-70e9b1dc61e5@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4ff8abad-186a-41b7-a269-70e9b1dc61e5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62A464000B
X-Rspamd-Server: rspam10
X-Stat-Signature: st5g6j6dgugbwmabrxomkfcjhcpwbzun
X-HE-Tag: 1766063340-625482
X-HE-Meta: U2FsdGVkX18hy6q2fbosxMH14Pb20DuxJA/vPt5MJG2yeBZJnL2gOWMLczFZqciWjDExBgAvGd9Lq6JXKzd+Vy5tLaj1qVowTnhfv3RPKPjQhCXoolU1+UVfDevQTZagavzvAJYP0lsMrIbD2XxXSJ/goR9WJ/lEY76EN8q7V1YFkJpAlckc+z4hYSbJvo9Wp5UqbHfZ8R1laG/+GvTZq00OI9XGZT5DMMYMqWF3z9pnjRaW652JPzBttTN3Xzcq3dxJQznWinfqlQj9xN3RGO1pn51/Qi+kScVwcM5ZYhuS2PsR/r7VQf9GP7r2pl9avENu/3nyvRXXnNdBrc/O0NFQi5fax+zpPyeKmb4yE4eGLLHbxblk4MNdgtzphYs14FnvSqbjSAJ5GCThZQUChvBiCj3KJ8c6rPrxwxLotPoUMcA76zSmWr4aKVOK+lzQRxHyK4GyedxzMqZigeNW4YZE+I11lV0EPyMgrmTVvzNeW9HL4LBGxaxaui/FszeFC52tO2hIiRzk6o3OZ0aFUxMfunw13fcWqThtooDYxW4mbge2Baua2QQCXYEs8xCCcpM7LNB03+NaBbOYC/fJl0NUyh2rmm83YYUCgylg8ukefNdvzZgYOvjtuixgFw+wbQZOjo+w2azt3xS5artJWzq1Y+9IQmLAd6PQlhuc0qimC2j4EgrIVFZ4qJu81LM4PYuKwBi6oqUatFgacR011Hk6RSv4Tl+zWopUVf3FxSW9z8BD2uNXwZrSktkmiJdLOHfHrBOCboxUCjIGeCgfSmihqhHnvcge/P1IiULWOKw3LMpREpNowIXQG0l4bj96djF3SF83ypW98sAZFFvUhA83pLrHMyNczcgC+Aev2HlOmNymrfKneZUf1GXOlnnFhr2EpFbcqbD3pt4p567eeCZ8ra91kTzHyjH4U7fe91Ky2X7X89Y7udxaPM4lp9u3euOdTDN77jN43KyMs1i
 zSWQqiYD
 2C5RFsgIleMLeE2T8uFqArmRtvooJyil36/ih/LvjogDVCvIRvcHRK3uLczVvas/yTRDGQbzDAUkIOLMOLcCimYF8mxlXTgsIUzFoKw7et6B+Fv/lONApK8Hmt0Gk8XnVcDEJ6KLa2R2TwzzyrBLlHmtayxtSB8MFClVJHcNvbNdFXIK+YVGBq1nbShx7OGMq/jerM68LeoU0WmXBbaTmU5wGaaONmpVPiyAcpXGhTJVmdKIqt8WXUlt+VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 06:48, Lance Yang wrote:
> 
> 
> On 2025/12/13 16:00, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When unsharing hugetlb PMD page tables, we currently send two IPIs:
>> one for TLB invalidation, and another to synchronize with concurrent
>> GUP-fast walkers.
>>
>> However, if the TLB flush already reaches all CPUs, the second IPI is
>> redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
>> completes, any concurrent GUP-fast must have finished.
>>
>> Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
>> their TLB flush provides full synchronization, enabling the redundant IPI
>> to be skipped.
>>
>> The default implementation returns false to maintain current behavior.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>    include/asm-generic/tlb.h | 22 +++++++++++++++++++++-
>>    1 file changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>> index 324a21f53b64..3f0add95604f 100644
>> --- a/include/asm-generic/tlb.h
>> +++ b/include/asm-generic/tlb.h
>> @@ -248,6 +248,21 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
>>    #define tlb_needs_table_invalidate() (true)
>>    #endif
>>    
>> +/*
>> + * Architectures can override if their TLB flush already broadcasts IPIs to all
>> + * CPUs when freeing or unsharing page tables.
>> + *
>> + * Return true only when the flush guarantees:
>> + * - IPIs reach all CPUs with potentially stale paging-structure cache entries
>> + * - Synchronization with IRQ-disabled code like GUP-fast
>> + */
>> +#ifndef tlb_table_flush_implies_ipi_broadcast
>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>> +{
>> +	return false;
>> +}
>> +#endif
> 
> As the kernel test robot reported[1][2], the compiler is unhappy with
> patch #3:
> 
> ```
>      mm/khugepaged.c: In function 'collapse_huge_page':
>>>>> mm/khugepaged.c:1185:14: error: implicit declaration of function 'tlb_table_flush_implies_ipi_broadcast' [-Werror=implicit-function-declaration]
>       1185 |         if (!tlb_table_flush_implies_ipi_broadcast())
>            |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      cc1: some warnings being treated as errors
> ```
> 
> I'll move tlb_table_flush_implies_ipi_broadcast() outside of
> CONFIG_MMU_GATHER_RCU_TABLE_FREE in next version, making the complier
> happy on architectures that don't enable that config ;)

Yeah, that's probably cleanest.

-- 
Cheers

David

