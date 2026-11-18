Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9315606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SXQTfpLU
Received: by kanga.kvack.org (Postfix)
	id D40D96B05B1; Wed, 18 Nov 2026 01:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18EB6B05B2; Wed, 18 Nov 2026 01:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C562F6B05B3; Wed, 18 Nov 2026 01:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97E8D6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:17:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BBDF160696
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:17:25 +0000 (UTC)
X-FDA: 85447232850.22.D05A5BB
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE8AF40005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:17:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SXQTfpLU;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794982643;
	b=bYkR0H1ZRyZfLD7XRXbUpslQDl5DcOJFStJYDnCEowV0LdK/Jbpwd40SBjF/sxPDXSwlCl
	gDDQup31cpKazTevQV1ZboYnD7bJD38g8S/45WDIeD6hQxZM9gkRs3qIEdYZCuQqw1ntaq
	TBODgB9UsNAVeA7hSK+DF/aJNz0+Wh8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SXQTfpLU;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794982643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9fOIxOwET96uC8roh03DOKW3+w63/lkWzkOzpEHPkw=;
	b=AKX0FTfHzIr9qF1euPt1l/IqAaI3dXKkIIyo+l9rgl0UDMrxSpkAmAk6zTSG5GOX4WHwRN
	JXVnTEVHFusU+PO+ciXPXjrDaFL/FC4zKsgP1y3ZZypsB6hxDwlQUMuPj29ONQNzpQYd0o
	X4RfztLc8dxEg6pRemJYEo3AhWZNPOQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794982639; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n9fOIxOwET96uC8roh03DOKW3+w63/lkWzkOzpEHPkw=;
	b=SXQTfpLUbsyg5O3S9zlnRvhaopJz2jQDYm6HKEOcIWEXu+Kzjd2N3bN/bOAuoXLK8RPC18NpSANmB6Wvr7tmB8sB57NjZNi5F2OlQHg/drU/T+zAa8M/oUIXSKz7aF6WnR/SCK9Uxrg5nkY/SDvA3GL9x2SXx9iA8heQGme3AGg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF.fYJZ_1794982636;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XF.fYJZ_1794982636 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 14:17:17 +0800
Message-ID: <1001fb37-5db0-4b25-9807-0cc39d9ba03a@linux.alibaba.com>
Date: Wed, 18 Nov 2026 14:17:16 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: use memory barriers for non PMD-sized folios to
 sync
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <6274e62645b9f176dd10d7a79e86b900a39cec5f.1794898535.git.baolin.wang@linux.alibaba.com>
 <avxb050XeV895evT@gremlin>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <avxb050XeV895evT@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE8AF40005
X-Stat-Signature: bg45uz9xphp97ueu1w4ammfx69wkdjqt
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794982641-41091
X-HE-Meta: U2FsdGVkX19lZWkzyhlb3VFTldGZ0IngRF5xjcPDwAdheksIyAmBPGvvAvT2R4CJBsYGfqvH4HtYvoFz8nrz32UQpwfpBilqMev3UqCIxwxQlh6Btb0ANjN9ilj0xBaM6keKv42ainm8pyAj6qJiwMrmZC9SWSKkx0KGPCIqqVy3dMDYd8OM+d2isgS5rWC7ZROWdLGuAsphkMVrxuOyHgstq1T/JX1wcvc00pHM2uH0r8E9gN7a3NFWagmR9Y3ESfvmwpODbOneuIZegsajHMklLa1C2Mr09gHksPAsDek4geLZbCe91+dThVvL/4Y2fB9c32fg1GtUTsJV3XJ89/B+8+achD5s8fE39ZJRp5YDJENgkBZVn4FSvKZQskzpR9aw/YteO7eNAbSbugWd3n6QqNCCHpklslh+rRmOJQ8D+2/i8jcUUp9n0tZ36hKvzY2T9Von9vn05ZlXuB3PKvSwMkwmvdfhYEK2XQl4hrnHS7O92Qv4igWciA/XR9/j6qnXUYHGEXQkl6F4Uf+Vn952E86IaMhT7M36zxpJVg/8SFTlTfpFBbN1K7rbWr6pOrKxK/EuczyeqT88LPytDrSUsWXZ6CSt3EWe0xyuqkuukqRgTAsFodW7FyXkKy0G+roTvPN6nFKrMs66GgfSLSgFSa+RZd76kbmed1LU3O9rscUgaebL69QYU2Wtt1B8oKolzmPMeQRGlS5yO7gG+iLMt3x7qqZQAcbnUbclpoqKipe3YUDqYSRv0ssR4HXiBr7+59j+AfOKFsbOP0gc/RAtM2zmxgeFDiQ2n0leZvgVPTg59aweDB3HOQfftUpGcQv2eBr6YfKpnLzfm59eQQ44H7bfSKjnwTAFGkN2lk8KixL9e3G1T25soHA8mZ7Kf+lu0T7YWEasZED6HsRtoneuJCU/C7aKKz7AVZZbRqvFsB8EI4NM+1EBtCvfrDYv5j8o/70dPm84uCO04iN
 oq4hZhcA
 zCgmlFZM1qNdMbEfq8cSlZY3oYIvUnyAKZhIYImpeZCXDsSUPl+uV2OTRif5ktjRkaM3i2BaZ/0tJswnaBr94s0LxG+bG18YMMf6wWRQwAva15il1EeB4DOlAmMqy6ZCYtIEgl54IjoNsb2ipxVZZBMQxPp4+tEI9+qH0b0HNAv85j3YArdWPaOY3VjPZ9e4UGhIfbp9E/uyfcpx7LN9wh//+VPumAngpwrMTIXWghYMztrhINlZoDIiJGHho9rFexIxi+AnuIjBnoEuuMOHn3aLBRIcEf7jEecJhNBv5HPqJs0+M7/gcUZWdFCuSR+golWUo0HvD2+mtH8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 9:53 PM, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 17, 2026 at 03:00:30PM +0800, Baolin Wang wrote:
>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
>> uses PMD lock via sync_with_folio_pmd_zap() to synchronize when a cleared
>> PMD is found while unmapping a folio.
>>
>> However, for non PMD-sized folios, the only PMD clear that can race with
>> this unmap is PTE table reclaim, which clears the PMD only after the rmaps
>> for the table have been removed. This is plain message passing, and taking
>> the PMD lock is more than needed, like I did in the previous patch[1].
> 
> But it doesn't automatically mean that you _have_ to use fragile memory
> barriers?
> 
> Correctness and robustness in the future are important right? You need to
> justify this properly.

Sorry, I wasn't clear. The point of this patch is to avoid a possible 
performance regression from taking the PMD lock to sync for non 
PMD-sized folios. So using memory barriers can avoid this.

The description below explains why memory barriers are enough here.

>> Without barriers, the walker can observe the cleared PMD but a stale
>> mapcount on weakly ordered architectures:
> 
> You mean without the PMD lock?

Yes, will make it clear.

>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>> ================================    ================================
>> folio_lock()
>>                                      lock(ptl)
>>                                      clear PTEs
>>                                      remove rmaps   /* W mapcount */
>> [mapcount load satisfied early,
>>   folio still mapped]
>>                                      pmd_clear()    /* W pmd */
>>                                      unlock(ptl)
>> pmdp_get_lockless() -> none         /* R pmd */
>> skip the PMD
>> folio_mapped() -> true              /* R mapcount, stale */
>> unmapping assumed to have failed
>>
>> Pairing an smp_wmb() before the PMD clear with an smp_rmb() after the
>> PMD read forbids this outcome:
>>
>> CPU 0 (unmap folio)                 CPU 1 (MADV_DONTNEED, full PMD)
>> ================================    ================================
>>                                      remove rmaps   /* W mapcount */
>>                                      smp_wmb()
>>                                      pmd_clear()    /* W pmd */
>> pmdp_get_lockless() -> none         /* R pmd */
>> smp_rmb()
>> folio_mapped()                      /* R mapcount */
>>
>> If R pmd observes W pmd, R mapcount must observe W mapcount, so
>> folio_mapped() no longer reports the removed mappings.
> 
> This is insufficient IMO, you need to explain firstly why acquire/release isn't
> feasible (presumably because you can't synchronise the clear properly that way).

Sure. Using the PMD lock (with its implicit acquire/release semantics) 
would also work. However, as I mentioned above, the concern is the 
potential performance regression.

>> Pass a 'folio' parameter to sync_with_folio_pmd_zap(), allowing us to
>> skip those pfn walkers: pfn_mkclean_range and mapping_wrprotect_range,
>> which don't need synchronization.
>>
>> Similarly, skip sync for page_mapped_in_vma() since the subsequent
>> operations don't check the folio's mapcount.
>>
>> No changes for PMD-sized folios unmapping.
>>
>> [1] https://lore.kernel.org/all/542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> This replaces an easy-to-reason about lock with a very-hard-to-reason about
> memory barriers that are fragile and could easily break resulting in subtle data
> race bugs.
> 
> And you don't seem to have provided any perf numbers or anything to justify it
> unless I'm missing something?

Yes. Performance measument for this race path may be tricky, but I'll 
try to see whether I can show a measurable benefit with memory barriers.

> I'm a little uneasy about it honestly.
> 
>> ---
>> Changes from v1:
>>   - Pass in a folio for sync_with_folio_pmd_zap(), per David.
>> ---
>>   include/linux/rmap.h |  2 ++
>>   mm/internal.h        | 26 ++++++++++++++++++++++----
>>   mm/memory.c          | 12 ++++++++++--
>>   mm/page_vma_mapped.c |  4 ++--
>>   4 files changed, 36 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 74cca0e3c726..62e7341de179 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -862,6 +862,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>>   #define PVMW_PGTABLE_CROSSED	(1 << 16)
>>
>>   struct page_vma_mapped_walk {
>> +	struct folio *folio;
>>   	unsigned long pfn;
>>   	unsigned long nr_pages;
>>   	pgoff_t pgoff;	/* Only meaningful if nr_pages > 1 and not a KSM walk */
>> @@ -876,6 +877,7 @@ struct page_vma_mapped_walk {
>>
>>   #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
>>   	struct page_vma_mapped_walk name = {				\
>> +		.folio = _folio,					\
>>   		.pfn = folio_pfn(_folio),				\
>>   		.nr_pages = folio_nr_pages(_folio),			\
>>   		.pgoff = folio_pgoff(_folio),				\
>> diff --git a/mm/internal.h b/mm/internal.h
>> index cd3675c044e0..ad7e051cb198 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -592,6 +592,7 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>    * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>    * @mm: The mm_struct.
>>    * @pmdp: Pointer to the pmd that was found to be pmd_none().
>> + * @folio: The folio being zapped.
>>    *
>>    * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>    * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>> @@ -600,13 +601,30 @@ void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>    * against later mapcount reads. Skipping the PMD without synchronization
>>    * could make folio unmapping code assume that unmapping failed.
>>    *
>> - * Wait for concurrent zapping to complete by grabbing the PTL.
>> + * Wait for concurrent zapping to complete by grabbing the PTL for PMD-sized
>> + * folios, otherwise smp_rmb() is sufficient.
>>    */
>> -static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
>> +static inline void sync_with_folio_pmd_zap(struct mm_struct *mm,
>> +		pmd_t *pmdp, struct folio *folio)
>>   {
>> -	spinlock_t *ptl = pmd_lock(mm, pmdp);
>> +	if (folio_test_pmd_mappable(folio)) {
>> +		spinlock_t *ptl = pmd_lock(mm, pmdp);
>>
>> -	spin_unlock(ptl);
>> +		spin_unlock(ptl);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * For non PMD-sized folios zapping, concurrent zap_empty_pte_table()
>> +	 * may clear the PMD after the rmaps for the table have been removed,
>> +	 * but later mapcount reads could still be observed before the PMD
>> +	 * read, making the folio appear to be still mapped after unmapping.
>> +	 * Order the PMD read before later mapcount reads, so that observing
>> +	 * the cleared PMD implies observing the rmap removals.
>> +	 *
> 
> This also makes me very uneasy, complicated reasoning like this is asking for it
> to break.
> 
> Also could this be smaller and clearer?

OK. Let me try.

Thanks.

