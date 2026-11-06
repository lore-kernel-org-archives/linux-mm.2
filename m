Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9B3606D833
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rSzg3o7t
Received: by kanga.kvack.org (Postfix)
	id DE53A6B05B5; Fri,  6 Nov 2026 04:50:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE8C6B05B7; Fri,  6 Nov 2026 04:50:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC9D6B05B8; Fri,  6 Nov 2026 04:50:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF7346B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:50:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 665EB1A0D1F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:50:28 +0000 (UTC)
X-FDA: 85404224136.09.BAF0E1F
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id D3CEE1A000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:50:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rSzg3o7t;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YgTsCFiWpYDpwX2W1OwuCrARSq0xJat5oiGwU5Idm8=;
	b=iw7MadqGD2C9tVOz2h6NBTBAAaXBeUXghsggPiV/vBsv8bL8mBI2nDouoIeGkZ9WljspK1
	7t5DlFR2PcdwHKn2eUQSai/AdsS6JHmULmAqlaUctComb2lYaKOJ2OyrU6qsvzD/jMzcST
	qVb78eIpZrbTShfk7baFf2RGXE+Dubo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958626;
	b=7704jU+5udTVRzQrPDtwfufswS8nIgpDHEZJeI3hL9wv847GskvjZlFid9an7CewExlF5k
	I9ZWkZwgtFS9iBTZ0862YFriwX7Nmnib8rGDqxLbVh1iYK2VwF9h82KeetZOo6OfZb8hUi
	3lq8OFv8SgBRVlaD3miAKbZsEdamYKI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rSzg3o7t;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793958622; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6YgTsCFiWpYDpwX2W1OwuCrARSq0xJat5oiGwU5Idm8=;
	b=rSzg3o7tJ74XyaG5qORRfV5OA0uXY+W2AhsZagvWyzmT0Ecw8RGyHkbtCMJ8lPa+Lm4HLyVMZH4T/ozJPSY+PnL2KwaxpuzzSlHz58kCkbrcyFS1lYon3KTFi0JKznmHFeyiAkjACf8dn+nehAKGluUV9SedF92sgYp1lB8KOyc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEBSw-4_1793958620;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEBSw-4_1793958620 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 17:50:20 +0800
Message-ID: <def293c7-a432-49e2-8082-9ffb427d192c@linux.alibaba.com>
Date: Fri, 6 Nov 2026 17:50:19 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Lance Yang <lance.yang@linux.dev>
Cc: baohua@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
 <20261106091510.67980-1-lance.yang@linux.dev>
 <09095de1-3916-43a9-a217-ae8564ba4d4c@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <09095de1-3916-43a9-a217-ae8564ba4d4c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 94r1arcc9tstjum5fuorgkcqewipepif
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3CEE1A000D
X-HE-Tag: 1793958624-523861
X-HE-Meta: U2FsdGVkX19ngZcJer82ynsmSBYhccnnITjRzkblDIc+h4W8CgIo4ZUfGXkjX3+Ge7ucR+j8Al7nJRc/rUXQtG0oX5lvTsMBSQX3wo8qpxNjF/84LOHUht6r/7FUFanfhYCy93iDEPRvJ673VxTgMOMycGKCD3TyJGiX/fLH36Oyvos5r3A4UpK+XFt/IKkQCSptlW2cHTb9c/RCq0Sm35j39cSfiISnXu0O71gDO6EMRxP5YMw47nj21p9jw2g5hXugzHTujJzBj02O/U+sqYP2SsccaeAxD09A6XOdoA5PpWonA+ThTA1de1rJc5GOpSyrVexR15BkVyVCktw6gpI9HoMJtw8rl/sLUvcaBNe3BdUpt2tD3nxEp6IigQvriHDUKm9IkhJ1eJpe1ijNowfdpXIj98rl/xHHhJk6e5bzwQf/btB8LWI83eYSSkSdTCAG+NR/vzHhNdE1HuqM56rDJzULG/mNxy5zUJVxBRRiPIdxVLmDBanibKYEOb1RR5z0d0LxLyPOToMilWGfWA4/BuO3wQLAZGwW201o5NTSQUfg4sHvXeW9TZCXV4UqhDFS5hs7VSQva3yQ5XXoNFd/gzjSqDxxSWSfSHX32t4x/1XGFNApMzOG8bbU3oO4/nxBZYAiamTgBbQOEeWViIA1ORkgfqzBq4P/+IZyVODusYmi/Mfw9gt/AuGCluKu7yarua1Yc9CpJzyhf1xaAu61X520Ehm6aOxFtEGJxv0dY3zg51oHQxou0CMte9i1zPO8NHXFA3m5X1/Wja1zoWQQ41Z75d+0nGqJAMEIHd5zXZnxqQQbAGxm6oIIHZngMZV8fIxOhydOk1m8Ro3utZQlhRhlGY/oV5Ar/2XcuzR9QDkfsuhWL+qjoNWPOVxId7WzRpkJX0qCxsBBggevEKICwm7W4HOHHEw2935nECM3RbJrkQ4L/fOtcLwcdRBgzAM/tI5nX2jB1GF3Grg
 KbGq488m
 7xjlVTxeuiiqLrW+9RQEozp1rUOk4NB6AnI6B0UtFMmNKdTsBnRL+i9Tq9ebtGVVTn5iv+OhbFMXmE9Ml81+l4ZwWzI2ascjmAycnSqgns7qOP/aTJED2vqOE1bxOA7FydfM2J2y/kl5a04d+Po0oJWnRcozI2oayG9zHRIx6GTdC+wG3rseGozTHPom6T7PFAymrvb1S1e1HKxLcd9Jez0nLSfumzFdiEOqicdFuu8w8ChVmNm3a64/Tggn2yo3FPZkFgmhOKum9iEYsLiWbeE+767VV38xVURb+RlPCsn/NQVhQW1DbQ2bDk6cm/PMKIjAxtvQnC9OpDMIarg7SM7U3PJOkjLS0uCma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 5:29 PM, Lance Yang wrote:
> 
> 
> On 2026/11/6 17:15, Lance Yang wrote:
>>
>> On Fri, Nov 06, 2026 at 04:54:44PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 11/6/26 2:24 PM, Barry Song wrote:
>>>> On Thu, Nov 5, 2026 at 5:00 PM Baolin Wang
>>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>>
>>>>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>>>>
>>>>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>>>>
>>>>>>
>>>>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>>>>
>>>>>>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>>>>>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation 
>>>>>>>> removing
>>>>>>>> mapped
>>>>>>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can
>>>>>>>> also race
>>>>>>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>>>>>
>>>>>>> Good catch!
>>>>>>>
>>>>>>>> page_vma_mapped_walk() is used by many functions including
>>>>>>>> try_to_unmap(),
>>>>>>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(),
>>>>>>>> remove_migration_ptes(),
>>>>>>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for
>>>>>>>> try_to_unmap()
>>>>>>>> and try_to_migrate(), the other callers do not perform post-walk
>>>>>>>> accounting
>>>>>>>> checks, so the race has no observable impact on them.
>>>>>>>>
>>>>>>>> For migration, the race can cause unnecessary retries. For 
>>>>>>>> reclaim via
>>>>>>>> try_to_unmap(), the race can cause failure to reclaim a folio 
>>>>>>>> that is in
>>>>>>>> fact already unmapped (as shown below), which may lead to 
>>>>>>>> unexpected OOM
>>>>>>>> or increased refaults.
>>>>>>>>
>>>>>>>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
>>>>>>>> --------------------------------    
>>>>>>>> --------------------------------
>>>>>>>> folio_lock(F)
>>>>>>>> try_to_unmap(F, TTU_SYNC)
>>>>>>>>                                       zap_pte_range(full PMD range)
>>>>>>>>                                         spin_lock(ptl)
>>>>>>>>                                         clear PTEs
>>>>>>>>                                         zap_empty_pte_table()
>>>>>>>>                                           spin_trylock(pml)
>>>>>>>>                                           pmd_clear()
>>>>>>>>                                           spin_unlock(pml)
>>>>>>>>
>>>>>>>>     page_vma_mapped_walk()
>>>>>>>>       observe !pmd_present(pmde)
>>>>>>>>       nr_pages < HPAGE_PMD_NR
>>>>>>>>       skip synchronization
>>>>>>>>       return false
>>>>>>>>
>>>>>>>> try_to_unmap() returns
>>>>>>>> folio_mapped(F) == true
>>>>>>>> nr_unmap_fail += folio_nr_pages(F)
>>>>>>>>                                       tlb_flush_mmu_tlbonly()
>>>>>>>>                                       tlb_flush_rmaps()
>>>>>>>>                                         remove F's rmaps
>>>>>>>>                                       spin_unlock(ptl)
>>>>>>>>
>>>>>>>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>>>>>>> folios")
>>>>>>>> has already moved the PMD clear operation (via 
>>>>>>>> zap_empty_pte_table()) to
>>>>>>>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also 
>>>>>>>> needs to
>>>>>>>> use sync_with_folio_pmd_zap() to synchronize and avoid memory 
>>>>>>>> ordering
>>>>>>>> issues on weakly ordered CPUs.
>>>>>>>>
>>>>>>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
>>>>>>>> madvise(MADV_DONTNEED)")
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>> mm/page_vma_mapped.c | 5 +----
>>>>>>>> 1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>>>> index e6b6170c2f4f..8797467b6f0c 100644
>>>>>>>> --- a/mm/page_vma_mapped.c
>>>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>>>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct
>>>>>>>> page_vma_mapped_walk *pvmw)
>>>>>>>>               spin_unlock(pvmw->ptl);
>>>>>>>>               pvmw->ptl = NULL;
>>>>>>>>           } else if (!pmd_present(pmde)) {
>>>>>>>> -            if ((pvmw->flags & PVMW_SYNC) &&
>>>>>>>> -                thp_vma_suitable_order(vma, pvmw->address,
>>>>>>>> -                           PMD_ORDER) &&
>>>>>>>> -                (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>>>>>> +            if (pvmw->flags & PVMW_SYNC)
>>>>>>>
>>>>>>> Right. Whether the folio can be PMD-mapped doesn't tell us 
>>>>>>> whether its
>>>>>>> PTE table can be reclaimed, so those extra checks can skip
>>>>>>> synchronization
>>>>>>> that the caller explicitly asked for ;)
>>>>>>
>>>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>>>
>>>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't 
>>>>>> we still
>>>>>> hit the same race there?
>>>>>
>>>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
>>>>> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is 
>>>>> set,
>>>>> it means the caller can tolerate some racy checks.
>>>>>
>>>>> For this case, I think we should set TTU_SYNC unconditionally in
>>>>> shrink_folio_list(). Barry, what do you think?
>>>>
>>>> Baolin, thanks for reaching out to me. I added that flag
>>>> mainly for large folios.
>>>>
>>>> I observed cases where PTEs for large folios are partially
>>>> cleared during certain transition states, for example, when
>>>> PTEs are cleared before being modified:
>>>>
>>>> pte = ptep_get_and_clear();
>>>> pte modification;
>>>> set_pte_at();
>>>>
>>>> In such cases, page_vma_mapped_walk() skips the empty
>>>> entries and starts from the next valid one.
>>>>
>>>> This may result in partially unmapping PTEs for large folios
>>>> and trigger unexpected folio splits. At the time, I was
>>>> particularly concerned about unnecessary folio splitting,
>>>> so my focus was mainly on large folios.
>>>
>>> Thanks for the information.
>>>
>>>> However, I also noticed that a similar race can occur with
>>>> small folios. In that case, the folio may simply remain
>>>> unreclaimed by the reclamation path.
>>>>
>>>> However, my main concern at the time was avoiding
>>>> unnecessary folio splits.
>>>>
>>>> Your new race also seems to amplify the same situation.
>>>> However, I don't think this problem necessarily depends on
>>>> the commit you mentioned. It has been around for a long time.
>>>
>>> Agree.
>>>
>>>> If the concern is reclaim failure, I agree that there is no
>>>> fundamental difference between large folios and small folios.
>>>
>>> OK. And I did a quick measurement to reclaim anon and file folios via
>>> the memory.reclaim interface.
>>>
>>>  From test results, reclaiming 1G small anonymous folios (using zram as
>>> swap) shows no significant performance change. However, reclaiming 1G
>>> mapped clean small file folios does show an observable regression if the
>>> TTU_SYNC flag is set.
>>>
>>> Without TTU_SYNC for small folios:
>>> time echo 1G > /sys/fs/cgroup/test/memory.reclaim
>>> real    0m0.178s
>>> user    0m0.000s
>>> sys    0m0.178s
>>>
>>> With TTU_SYNC for small folios:
>>> real    0m0.315s
>>> user    0m0.000s
>>> sys    0m0.314s
>>
>> Nice numbers, cool!
>>
>>> So for the current patch, I'd prefer to keep things as is: only sync
>>> when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the
>>> original logic, meaning the caller can tolerate some racy checks.
>>>
>>> Any other thoughts?
>>
>> One thing I want to pin down first, for the order-0 folios, was that run
>> with TTU_SYNC going through the pmd lock, or did it already go the
>> smp_rmb() way?
>>
>> My guess is the first one, right?

Right. I didn't add the memory barriers optimization (will do in a 
follow-up). The test changes are as follows:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..6a95a4fdc64c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1434,11 +1434,6 @@ static unsigned int shrink_folio_list(struct 
list_head *folio_list,
                  * processes. Try to unmap it here.
                  */
                 if (folio_mapped(folio)) {
-                       enum ttu_flags flags = TTU_BATCH_FLUSH;
-                       bool was_swapbacked = folio_test_swapbacked(folio);
-
-                       if (folio_test_pmd_mappable(folio))
-                               flags |= TTU_SPLIT_HUGE_PMD;
                         /*
                          * Without TTU_SYNC, try_to_unmap will only 
begin to
                          * hold PTL from the first present PTE within a 
large
@@ -1451,8 +1446,11 @@ static unsigned int shrink_folio_list(struct 
list_head *folio_list,
                          * try_to_unmap acquire PTL from the first PTE,
                          * eliminating the influence of temporary PTE 
values.
                          */
-                       if (folio_test_large(folio))
-                               flags |= TTU_SYNC;
+                       enum ttu_flags flags = TTU_BATCH_FLUSH | TTU_SYNC;
+                       bool was_swapbacked = folio_test_swapbacked(folio);
+
+                       if (folio_test_pmd_mappable(folio))
+                               flags |= TTU_SPLIT_HUGE_PMD;

                         try_to_unmap(folio, flags);
                         if (folio_mapped(folio)) {

>> If so, please keep the fix as is and only sync when the caller asks for
>> it (at least, order-0 folios should not go the pmd lock way) :D
> 
> In addition:
> 
> For order-0 folios, we'd miss reclaim and reactivate a cold folio.
> 
> That doesn't sound too bad, especially for such a rare race.
> 
> so keeping the current behavior seems reasonable given the sync
> overhead ;)

That's also my thought:)

