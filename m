Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FC6C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3657D6B00A5; Tue, 22 Sep 2026 08:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D396B00A6; Tue, 22 Sep 2026 08:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253026B00A7; Tue, 22 Sep 2026 08:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08AB96B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:48:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90B3012043F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:48:47 +0000 (UTC)
X-FDA: 85241377494.14.2D5A9E3
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F90F180005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:48:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScIUg1yc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081325;
	b=BQRvuriNNs2VTun5x7pNqRofBdLv8j12Pgikkx/FSVpGcIqyLyZ43N/P/d1HBBOnNJXweh
	CdnmDYQivp1XLV9nTbqd4BW3C02kay6z3Ws6AQAeDrUKx5ZQu0228VY8Jx8B9sO51cMfcE
	Z22RiuGBouWIrGfaJWqPhIjFSgzHfA8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScIUg1yc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZ2EsFqUDwfmy1FFAA3c/7iXb9TKQyBEfPBHU5aaf3Y=;
	b=VI1T0fIPH0aVZ1NtvynFMwBnaDHSIKnymVYjNjA3Z/5tC/eo75flLWEjXPLoHz2oF7SFhA
	7jF8Gk33ZTnZ4D+Wl5/n1lnIeYu55y9txinS0yRNQEvJanScHCrEl5d2GZ4K72YpWfrYPd
	Cqg68T5612Mb0LE6+Tw492OPYQvhM0s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wzEk4sVRhnKEVhasilKpOv1uZCDcHlKB164cBBTlxVg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790081321; v=1; x=1790686121;
 b=ScIUg1ycfRo/nD9Kja2lpXBYOE6RWOnBn+P75dYa43XguSRz+XP4POoPKz98trp/QpBrVHe0
 zYBLxubVICiMqLMjFPjAd8/d0I2Q0/pPjmrpGpCzkFzVGKY3i+okkxseYrGdTH8OxuOdB74euNu
 ZMqgqTHrc4MUktsCQy/swjYU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ef79b9281d7277d;
	Tue, 22 Sep 2026 12:48:41 +0000
X-Mizu-Trace-ID: 5ef79b9281d7277d
X-Migadu-Flow: FLOW_OUT
Message-ID: <fada6164-9d84-48b6-b2f1-18f9a18c1590@linux.dev>
Date: Tue, 22 Sep 2026 13:48:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 04/29] powerpc: mm: add PMD swap-exclusive helpers
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
 Madhavan Srinivasan <maddy@linux.ibm.com>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-5-usama.arif@linux.dev>
 <47ccd5ce-2301-4ddd-881c-d57cb82b562c@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <47ccd5ce-2301-4ddd-881c-d57cb82b562c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: n6ob9dd6tgsdnhdtqt8uwi7ubjfdia4z
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F90F180005
X-HE-Tag: 1790081325-283675
X-HE-Meta: U2FsdGVkX1+SeJ0GX3uGT+QSaOwKWZPxQElPmizUG3GJ6lrldvI+i07gfOOevRF3OgMB8R8ABw6eJBfeFaFRLxdaCGYgvE6vfFLJU5akYVzndul4ecZZF37iOPzoIYfJVtnZTgakNINzPRXgpRRFzliBrSTMLbDfPHlugSgpG5I1kjVahd5vVScj9EcQXrhmmQC7qHWEbvHsc/z+ezc6mwiraQiGpDVl4OFjplTXql66FE1n91m+v0gfuBPdvEolAiuUUoWlgPmKqQxkycUfAlPfiyV1DISPuv2+iOE0cUo6jwnClReJhAT/4efwAkpDOwhuMGxSOY7L1H2H0tklFSvOu357JWQFIRkG5335SseJh97FPQXXC2XUsNgLz96MHiP4p2TERW2X/1T+GXeQ2BtW1LRSGegh1WwB5z1VInnXpXGueD5UB4kA2Pb8smngb4TfsA7Z2idB4oD9OiyMJ+6aIPriu1hXF4ANVbB3u0CM+8CZSwW6TKLwOOq0W5I9Zy7GiZIJVk2kLPiSs12jc/tB60XJaDMDJr0VyjHKC+VX5wnqTDH/oOKNX4vj17A3m4wqpqkct8tWGEFcBDXvUAeFYa2YKLmEVz5p+xfCOIxckWjS0GX+gYR6Ke6TWPj5HBRTshcOg4vVJXGW6WpWvLxRlhChKhvYa8ixMDjHaRM+5AEkX/K2vELn7cYCr/YcUCYgdhNbGDMP5IsftOH2L0Cz3tLoyAVVVcpPFNbnnhlnn7v2/Dylb9GkWtD4DP/kJFDdRauAvMcq8BMFhxlSDlPZ3msQQe3dwe/wP1NZyGU8X1rtrKhuIO1UNQRNGHHBydPh2CQA11USD6+Ncvphs72x3ThWk2Hmmb4BbP9TC1TJs5cqeDVWYX9LV375yBA8lvJx3jaibB+0muaZshXHRIF6hXPC/bkmSK6u51f4xtUu5cz13X0pAZLd6tRS49hm56DYwRx9Ido+VrTdt+J
 7ktD1GEM
 BQsMOjm71KCbfrc31c7ORYa09ktJ3XkWtI6FKjy2Wj2AGH+JYCXCkv+PK5U2uiG63IFDa59ojP56cSqUORqywTKYSt7gWFgUJuOeaKdmf74UUcZYGFrVnA1XccYaxiriesRiD+ccd5QyTS9t79YsdafDuDLt15S8/Cw5hPh/4LHkE+I6Bamsd258fuSrNxREQtfAUq9U21dZHscj3bve6W6f20UmFi5OVKM7Jtz6+/PabrKjMt30B0mAOZmExnI8VYKdFiRQY9lEUO1sO6FgpikQ1zDwux9/KWYtHX/kk2L7mRdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 22:22, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:27, Usama Arif wrote:
>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
>> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
>> not just in a swap PTE.
>>
>> book3s64 builds a swap PMD by running the PTE encoding over pmd_pte(), so
>> the PMD helpers use the same _PAGE_SWP_EXCLUSIVE bit. It is also the only
>> powerpc variant that selects ARCH_HAS_PMD_SOFTLEAVES, via PPC_THP.
>>
>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> index dff8790a047db..28943ef3c1c80 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -699,6 +699,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>>  	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
>>  }
>>  
>> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
>> +{
>> +	return __pmd_raw(pmd_raw(pmd) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
>> +}
>> +
>> +static inline bool pmd_swp_exclusive(pmd_t pmd)
>> +{
>> +	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
>> +}
>> +
>> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
>> +{
>> +	return __pmd_raw(pmd_raw(pmd) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
>> +}
>> +#endif
> 
> This should likely go below the pmd_swp_mksoft_dirty() handling block?
> 
> For softdirty it's e.g.,
> 
> #define pmd_swp_mksoft_dirty(pmd)	pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)))
> 
> 
> Why can't we follow a similar model here?
> 

I had just copied from pte_swp_mkexclusive()/pte_swp_exclusive()/pte_swp_clear_exclusive().


I will do this in the following revision for this patch:


diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047db..458c85cebfa65 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,6 +1060,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */

+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+#define pmd_swp_mkexclusive(pmd)       pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_exclusive(pmd)         pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_clear_exclusive(pmd)   pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
+#endif
+
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {


