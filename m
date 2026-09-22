Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20275C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E2F6B00AB; Tue, 22 Sep 2026 08:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145DB6B00AC; Tue, 22 Sep 2026 08:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BC36B00AD; Tue, 22 Sep 2026 08:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9B336B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:51:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75BD2160447
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:51:23 +0000 (UTC)
X-FDA: 85241384046.27.A1DC055
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3611D1C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:51:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S0480m+6;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7lj/67anBil5iDkS/VtuZ686+QtWOa7eu39qDb4W7c=;
	b=jkN9G4Hh4hOZvHUyF05cRJm1tgkjBEMI37t4/3CY1pmsrvJpmr/tXP+WDGymJKsP/A9YEE
	rTj0FkFpuNZ2HvSsDgbD/iwmre5X+BiUC9AKXhzTaTFO1f50LxHHEKWIDVRDtME7ipPRgc
	76x2mHNYdEWLCvN7QczwSF1P5JCpVBA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S0480m+6;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081481;
	b=5ysh8RYKnBkhmsOsLdjfPIaE6w9R3GqAehSwESEJb03Vp5Bs3Lx3ri447jKPpdGKLFAxgc
	jvx7M+IfR694SUPoglADEpWKz8OORbYuE2Zcxokic3pVo5mCwiEVOWuiPmMsyh4ERfCQPL
	OfAo3X5Sm90eut7XTQczRy80ElqtAxo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rd7i7Ne1v4a3mXkwREpKYjo7sQ/rKatj8SZMtz3c+SY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790081479; v=1; x=1790686279;
 b=S0480m+634FRWj2LTAyjKoqOI3qOGnHrAbs1B4wVxSt8EvtByVnpFj26oUaE4xNjsT1XcY5L
 fG+hpZgKs3HSsQwkjBUHHIxuBitbD+eLfWhXya5wwMiXLra6+aqAOj8V2xXFpD/R0RZG2LWaJY1
 k5Owkg4HcqA/CQNToddYoKC0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2bd109f32689452;
	Tue, 22 Sep 2026 12:51:19 +0000
X-Mizu-Trace-ID: e2bd109f32689452
X-Migadu-Flow: FLOW_OUT
Message-ID: <78f80b94-e0d4-47d0-8b1c-3fd5d850a875@linux.dev>
Date: Tue, 22 Sep 2026 13:51:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 06/29] s390: mm: add PMD swap-exclusive helpers
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
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-7-usama.arif@linux.dev>
 <92d0078e-afdc-422a-b624-0a3ca9aa307c@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <92d0078e-afdc-422a-b624-0a3ca9aa307c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z9fmushq4heobmx8h1xth5j9xoj4yb9z
X-Rspamd-Queue-Id: 3611D1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790081480-988554
X-HE-Meta: U2FsdGVkX1+B1QRMEkUhXpXMkRShe01qURDP36QvAobfpFT0PFO0U1bop0ivT6/Ijpe7VPMCINfPHv5/Q5ety44oUKTxN57a0qqs+5z+wvajieNmfCB/gIEzZtPHrpIvTknp0g0XEpDfBxqOvyutfHi/hQlYSiQZjTwLa3EqLgYBID/mp5xddOkDMjVOx1nQauDSNFezV6dXNr+n3xjIub4UOnRZBK5s8qgQEs/zN/aprqUgIteh8BUxBp87hoHnNzhUKGJ9QrJYgTaZw1gmCOdsB7AbKg8vqbzEt/j3GOaZ5k0GEwzBlVRCw2RlMJb9MpB4396NqUHjpHEHMqW5FxmCsd++TJbq5D5kdIerfi2eZL3bKDme/LcIgh2G0vcDjT4OWnFAHFQAn5OIc8NyvMhJOolAOOrUQlE8kGbrojjvvPTE7Y6hOmlpC4suaTcPQMghDxtS3xaHhgBxg1pd7PHCUepdxyaM4XhbC2ZizIb7SrNB3ByuATMdyGG9SBAzNx4r+Pae1fwxWbALv/40IK9YbfkcHqeTDe6bmlSQ7Ks2GwFMeHO7gJOByGbaLn5VtLJrIrysOXqE/XeqlV4PNTVZfqPmOOY9tE2oyS0/GC5VVBmkOMJMGxqIa5ffcz0IMOUTkihG6oynMCEvx9MJOhn5WtXq1lpPfgmq21BUl0uIGL4jpcuBn97px7jDb0wYQz8s+e8jdmfhbUprvWP05zKSpe4upOuJ42/tASprCjm5bD9oDAjaI5v77/nD0lOQSUAFFmQcqOSAjEE2lpXXm+SL+NS3F0Vfbki+78VGxkMcOZj8uB9hcPw523ZSUnVZ0nENyefaA2F58rN/VWKy1nf/WjP63ydwItVA9h/dErm1OS9Ib/b+snAtouiG74qdOkfyFO5vlDcX69LeMdNGGRkz1yiAA7QDkYoYjO3E2qGxwV2mG/sGr5RiFvYUjL/LbpsyNCNmFG6vhqDJYOs
 IGBiPHgG
 SFKRXASN9QMf2XJdmkAPsH4iv4H46IineQmUJ43qOfwx4ncoszcv5nTuicPZojG1jjorEEJLQic6uRH2MGngIV72d4P2vMZSZ06vsiMptjZocUNC3/pbJABkMGoQxs7y9u9n3CFD9RIuGlYvhsoNOsmZ3MSYlbziWhmtVQxm5PBTvDT1s8yQscf0LA+FFnSdA8PSsbliauMSa/H4eD+lIYcw9V9aKbcLfVq72XkwWCASLKGjKfFOL1AP4FMu8FU7ipRboQEbaaQHQswcdtkmpsom/z7/8O9oymgL7F5vRWZyboJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 22:41, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:27, Usama Arif wrote:
>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
>> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
>> not just in a swap PTE.
>>
>> s390 is the one architecture where a swap PMD is not a swap PTE in
>> disguise: it is an RSTE with its own layout, converted to a fake PTE swap
>> entry for the common code. Give it its own exclusive bit rather than
>> borrowing the PTE-format macro. The two happen to have the same value, but
>> that is a coincidence. Bit 52 was documented as unused; document what it
>> is now.
>>
>> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: Vasily Gorbik <gor@linux.ibm.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/s390/include/asm/pgtable.h | 28 ++++++++++++++++++++++++++--
>>  1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>> index 2d5c2ab06de98..0790a0884cfab 100644
>> --- a/arch/s390/include/asm/pgtable.h
>> +++ b/arch/s390/include/asm/pgtable.h
>> @@ -333,6 +333,7 @@ void setup_protection_map(void);
>>  /* Common bits in region and segment table entries, for swap entries */
>>  #define _RST_ENTRY_COMM		0x0010	/* Common-Region/Segment, marks swap entry */
>>  #define _RST_ENTRY_INVALID	0x0020	/* invalid region/segment table entry */
>> +#define _RST_ENTRY_SWP_EXCLUSIVE 0x0800	/* SW exclusive swap bit, see mk_swap_rste() */
>>  
>>  #define _CRST_ENTRIES	2048	/* number of region/segment table entries */
>>  #define _PAGE_ENTRIES	256	/* number of page table entries	*/
>> @@ -859,6 +860,28 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>>  	return clear_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
>>  }
>>  
>> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>> +/*
>> + * A PMD swap entry is an RSTE, not a PTE, so it needs its own exclusive bit
>> + * rather than the PTE-format _PAGE_SWP_EXCLUSIVE.  The two happen to have the
>> + * same value; see the RSTE swap layout above mk_swap_rste().
>> + */
> 
> I'm not sure the documentation here is warranted. It's all documented above
> above __SWP_OFFSET_MASK_RSTE, no? I'd just extend the documentation there and
> keep it away from these helpers that just use the bit.
> 
> The fact that they use the same bit doesn't really matter.

Ack, dropped for next revision.

> 
>> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
>> +{
>> +	return set_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
>> +}
>> +
>> +static inline bool pmd_swp_exclusive(pmd_t pmd)
>> +{
>> +	return pmd_val(pmd) & _RST_ENTRY_SWP_EXCLUSIVE;
>> +}
>> +
>> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
>> +{
>> +	return clear_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
>> +}
>> +#endif
> 
> I guess we could move it above the pmd_swp_soft_dirty() stuff in the same
> CONFIG_ARCH_HAS_PMD_SOFTLEAVES block.
> 

Done for the next revision.
>> +
>>  static inline int pte_soft_dirty(pte_t pte)
>>  {
>>  	return pte_val(pte) & _PAGE_SOFT_DIRTY;
>> @@ -1900,15 +1923,16 @@ static inline swp_entry_t __swp_entry(unsigned long type, unsigned long offset)
>>   * Bits 59 and 63 are used to indicate the swap entry. Bit 58 marks the rste
>>   * as invalid.
>>   * A swap entry is indicated by bit pattern (rste & 0x011) == 0x010
>> - * |			  offset			|Xtype |11TT|S0|
>> + * |			  offset			|Etype |11TT|S0|
>>   * |0000000000111111111122222222223333333333444444444455|555555|5566|66|
>>   * |0123456789012345678901234567890123456789012345678901|234567|8901|23|
>>   *
>>   * Bits 0-51 store the offset.
>> + * Bit 52 (E) is used to remember PG_anon_exclusive
>> + * (_RST_ENTRY_SWP_EXCLUSIVE), mirroring bit 52 of a swap pte.
>>   * Bits 53-57 store the type.
>>   * Bit 62 (S) is used for softdirty tracking.
>>   * Bits 60-61 (TT) indicate the table type: 0x01 for REGION3 and 0x00 for SEGMENT.
>> - * Bit 52 (X) is unused.
>>   */
>>  
>>  #define __SWP_OFFSET_MASK_RSTE	((1UL << 52) - 1)
> 
> IIRC, __pmd_to_swp_entry() and __swp_entry_to_pmd() will lose the flag, which is
> the right thing to do.
> 
> So conceptually LGTM.
> 

Thanks for all the reviews!

