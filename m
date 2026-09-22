Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61308C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAA66B009D; Tue, 22 Sep 2026 11:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BDE6B009E; Tue, 22 Sep 2026 11:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549DD6B00A1; Tue, 22 Sep 2026 11:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324F06B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:04:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFF59A670F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:04:06 +0000 (UTC)
X-FDA: 85241718492.15.AA279FB
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7859C1C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:04:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Teu4L1D6;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790089444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un5kxF2Be0qSZZ2fJVvIy7S7fFkrTBjmPHWE9HhI63U=;
	b=kaZ/BRczLIWy9FNgxELpVn8ymhd9Yl9hWpZ1QhaP5Eiv49KIOwbwX/HgWTGawmJkMdQ5Vu
	9eqhM+DoyYNrevzJqbk5HhsW0y6s4RnKqmkpEV1muV96VyYPs1z/8F4c/R1tQ3V+fizOrV
	g4TyLX0hwiPbCnscSlXnimUrMpv2iIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790089444;
	b=Ox1hs96RRJ37WzbvcxGsCLVgwJs5KwGcvZ/Emga72gev6czDvFYgVOOxNDkFb2684wzDt2
	Fdd4niJ8Yw61j9fiKpWfEhO/B+ejOQsaKWW+rMcTo86raYAuYrv3gkMihWIXlM8dLRTVY5
	nrzx1Fo3D6JMsKhuzLDNP4M0qKy55z0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Teu4L1D6;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y+LCUdEE09122n2Tb/Z0cY6K/0y14n1YrOrFxuwwzs4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790089443; v=1; x=1790694243;
 b=Teu4L1D6KPXdg4JlVg4TkEg0rMIvLZ70JP/YisX9QG+hn42tg+BkITgA3qqgnagTlPDoOyDg
 qf4ssTHcPGcEsbHWjrx74snP44XIbcjlm57sQhytZiAh3vkjZudYZ+os2D2zP7JrXo/rPKKvSiz
 WvKPGIvAOrdHPprQe6AJqvl8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 56074787bb66b1d3;
	Tue, 22 Sep 2026 15:04:02 +0000
X-Mizu-Trace-ID: 56074787bb66b1d3
X-Migadu-Flow: FLOW_OUT
Message-ID: <1fe0f6d0-1d99-45f6-bc3b-7e78dc6047f8@linux.dev>
Date: Tue, 22 Sep 2026 16:03:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 02/29] arm64: mm: add PMD swap-exclusive helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-3-usama.arif@linux.dev>
 <35e42ccc-df8f-4703-b10d-f7c96b263e98@kernel.org>
 <93e71e27-86d7-4853-bbd2-756ac137a925@linux.dev>
 <64b10ef4-428c-47dc-a97c-59ba178a9044@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <64b10ef4-428c-47dc-a97c-59ba178a9044@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ojx3jxi4hh9zftn3pn7h6e95ezdwrgdn
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7859C1C0003
X-HE-Tag: 1790089444-302430
X-HE-Meta: U2FsdGVkX1+ViM0FbEVDAZeuilYCPvqF13EHPZygPenykT1gN0t0BhTI5LZ8RFBmY4BDvGWJvFqJ5e5k4cesRrR37NtggPf3wh1CKNh7u2uaSe7Y8wLPjp1vmSWHfEMPv8mHo6AL65M2ODlQ6/QyAM7ftL0MLaipgj6CoYnXTeZ/s792WP/8hr7Up8asV5NhepUkRcTH05pX2KS/iXAu+1B7Oc5ns7Li19cOixifQzvWoPCvsKwS2gjriHfz780wNeP+XI7oJQKmJ2tgfCHbIskITZ1wV8X8Gc/RGCQDP+jGKjlLt1IzhGBEF3/NSVbUkhiZzv9AH6uHV88rQ11oTz4R8OJPORLzu3ZMTbL0WKVuLpJwgUijQ32v+suSLeZI0h8CAMKgQXhvtBcTw0rLZbTNCep3R0gNAyI2aT6vUlTma5bwhCr3ov5nsvzQ+KMUbrfV6tWw+Sow63rV9yipDPGUUl09R+gvCKE6WHHT5yHj0VOeY0/tuZCwnbFQiGfgfWGjtDzyyXeloJJ4Lv/6akQ+lQdi41R41HO9lOLEmy0QxGLfvg+XVkrz9OeDn0jE1l9bnD2wC7WNaEJzr9rjK/DRHNsNW7mYN88rd2fbBZmsQC4Qs/Vij2pEh0Fgr7ON7cE67cUn3iqrMo2M6abzxo9AxMPec0Ul2KMVh7gTHbUkvVu2LuhWHFpblXrHNbCOyzAvRTogwsDuYSyj/GtS0skctWWHpvg666SwCckCsSZUI1eVGNz7oQNZYhwX3hpYlTnjFQW/ryIgOG3kiy6BP8S4EiMyOq86lg/+Ckp//HvZfwllHAnloaoTXxwnKw+PR5Bag+pkLTb2bAh5VOmADPG7rgF+1MKNi4fo3v+/QEv2NFrC7S2xG/HScxTTwp7knYeZ1cHAwCE2Sq4FJII3Nx2dcM+uFeuAZ1gGD9aPMjCBgQNoWcaSyxV28wO1qxnAXrAj5ihEDCbd5noozPQ
 3jvPk1w0
 60PHL6ttSoQrEnZu5q2Lcm/ImGPUJd4L2VKayI4czxt6214IirWsm3rJtZmsehAJuug92h3AqBBh1Vop4ic3fnbCtgTW4JWpSw5haoJyS0TqkITsG9GKeuxk2j2H2yyudyjIBdMNGCrN39ZpEzJTnpcge9SBc9kX92GaovHFyqaEVwWy+Vw9RyNPK6z6vZTM5t+cwDJqQIOh1YeFA3You+6GNZ7NKANkjOePiNQLCokoU/B9GNV3hq5a6mx8oyesHqPE17fwbd0pnYMP+fm4raJN0cT+TNvBsfrrGAbb6aa4AqgLFY8TB97UWhsQ/T1gzoPjdDje7lw8A9PAK0Gy6D4Xk9tuu64e9xR0KLT2OJNjGc8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/09/2026 15:45, David Hildenbrand (Arm) wrote:
> On 9/22/26 14:34, Usama Arif wrote:
>>
>>
>> On 18/09/2026 22:11, David Hildenbrand (Arm) wrote:
>>> On 9/14/26 14:27, Usama Arif wrote:
>>>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
>>>> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
>>>> not just in a swap PTE.
>>>>
>>>> arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
>>>> the PTE ones and reuse PTE_SWP_EXCLUSIVE.
>>>>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Will Deacon <will@kernel.org>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>  arch/arm64/include/asm/pgtable.h | 6 ++++++
>>>>  1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index e89ec5f4787b4..d3f53a601aed3 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -599,6 +599,12 @@ static inline int pmd_protnone(pmd_t pmd)
>>>>  #define pmd_swp_clear_uffd(pmd) \
>>>>  				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
>>>>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
>>>> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>>>> +#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
>>>> +#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
>>>> +#define pmd_swp_clear_exclusive(pmd) \
>>>> +				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
>>>> +#endif
>>>
>>> Why do we #ifdef that here, but not the uffd-wp swp PMD helper?
>>>
>>
>> uffd-wp is gated on CONFIG_HAVE_ARCH_USERFAULTFD_WP.
>>
>> If I removed the CONFIG_ARCH_HAS_PMD_SOFTLEAVES guards above, when THP=n, arm64
>> will use the generic macro which is wrong.
>>
>> I tried building uffd-wp swp with just ARCH_HAS_PMD_SOFTLEAVES guard and I got
>> the build error 
>>
>>   mm/page_table_check.c:232:20: error: implicit declaration of
>>   function 'pmd_swp_uffd'
>>
>> we will probably need a separate patch like:
>>
>>   #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>>   static inline bool pmd_softleaf_uffd(pmd_t pmd)
>>   {
>>           return pmd_swp_uffd(pmd);
>>   }
>>   #else
>>   static inline bool pmd_softleaf_uffd(pmd_t pmd)
>>   {
>>           return false;
>>   }
>>   #endif
>>
>>
>> to avoid the above build error.
> 
> Just to explain where I am coming from: for all these patches I took a look how
> the other pmd_swp_* functions where handled (and separated from the pte_swp_*
> variants). Nothing earth shattering, was mostly looking for keeping things
> consistent within these architecture codes.
> 

Makes sense, this is how I wrote the functions as well, just looking at the
existing functions.


