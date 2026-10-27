Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7A9606A334
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oNagiXlt
Received: by kanga.kvack.org (Postfix)
	id 6AC3E6B0693; Tue, 27 Oct 2026 06:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CA76B0694; Tue, 27 Oct 2026 06:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BED6B0695; Tue, 27 Oct 2026 06:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 209006B0693
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:35:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 965BB1A095E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:35:47 +0000 (UTC)
X-FDA: 85368050334.22.4B099FB
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8877A0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:35:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oNagiXlt;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpnrnogDp3V5jKMwt4GW3YPjYv2QdO8b81MyuVuvoUU=;
	b=fdCvz/Et19iaM3bXs6OO0V6dfNEy3Hv7WI0bH+qMIPFjmQigGR/m4AqhGz+8Nm/gL25ok/
	oz/2pOYUqcuWMhZ3RnVUgUET1+add2QHfllVWxVi2xNVobdwCKKHguxq2Ul34Twj6sT0Va
	PEAjpZ3JpKQT8r7jRe5p2OJKGEuSwy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097345;
	b=bfun0wdpRnoNG/mn3It2dOTE41BXaTWSW2pMBHgGyyU987kIaw6q7NX0K4h1kwWtfNq6Uj
	uJ7O34dUj1UOCwyGcbaHwsuuO03CMHAetTApNfr/zBBWVXmiDbea02jJkoTyc+VBE/uZGa
	tA4UGaRjg31syvK1ZpA6i+oRYcrc4cM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oNagiXlt;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793097338; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fpnrnogDp3V5jKMwt4GW3YPjYv2QdO8b81MyuVuvoUU=;
	b=oNagiXltmo/cmflhgDQwS0YqEcfG3Um3M2iRW7g98rOG3JaRZWhCOFTQi6fgI4kR/+b+7njqrKdtJncbHi7QiheYi2LKPZU2ESO80K6hXIwPNaHxyIQ6mFW+XqKtAQM+0F8Rh5DNdVCyXOx4P7bwLrGq+RXyNtEDHc06W6GhVh0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDdS0nD_1793097334;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdS0nD_1793097334 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 18:35:35 +0800
Message-ID: <de0b41fb-4ae2-46a5-afe0-c021134ebba0@linux.alibaba.com>
Date: Tue, 27 Oct 2026 18:35:34 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
 <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
 <87e32afd-75de-4407-8f0c-fb70b40d5eca@linux.alibaba.com>
 <81ee2c92-f342-4f7f-aacd-d9558e67a980@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <81ee2c92-f342-4f7f-aacd-d9558e67a980@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8877A0008
X-Stat-Signature: sxtegyxhpgrs657gsa1ehpxs1rygwutk
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793097342-355663
X-HE-Meta: U2FsdGVkX18GGhXNSQ8ylxqhVv2LCxaivfLV7Wlju/hC5xk3I2S7lxP0QKFZ8s0++p8LohemGV6SSWUX6agkUO3GNQ7k5n/79Y1ebJTGCKMfjqSZcQVXmXWencAr8EpdT7orQ+YESOe9vYMWs1edKuRftSaStQduVMN6xLIKLOQ3I5wzID19dvYFKorZsosUQSlitk8xD+qJTQd+0wwUO5YdWzkMXVlyhUnc3rjarWuSubHx3qnx1dCXj5ZVRJuTnhI/QY5Xa1ps4ELvRrk7frwLeXEvxx/wI8BxQtPolvM8AqSIMAJ2AcWCQR/qGTFVBA+tbsmWsxKvW8c9G2u/ONM5zidJcqv/dfkCPmWyMZTfr/HNm8aPn2TsjXQDjqq3082D1DEfAvE8QrJ6nC0WgpsRoX0qieH2JCPFrQ7n8ZnzOs3vqJfqCmqrpuil/3tnvpCVsnDQe5n1BTM1GM8B7e2usDAqUjgBhOksqwVunUMT9d0Ej+w7ePYi2FgXDd2O6MYQNDORPrvhvMASX8vL56W07C7ed2AY8clM+hwV75ECRkuZ1oZ8u5kzH2iWng779dNz/B9Xz5LGphTuAh9zxjXo5LOs/QMqEzpj+rxb8NHOxA9WMp8LpnLdkJVCTMqkQ5a0ZLUAGkMTnOXBZOKQI1pTOZ4gC784E2xxPhAOogZhbtS4zDBilaa9P55rNgSNWubHiPyUwPR+jBDeTmdAxb1Wz5/ftEUJ3V9tJ8WjyAtmVoZHsmyt186mjwEJCUNJgUrF7tCU/vbIg7jkbMuV+11zLYq35oI4l3CfGisL5vgkIvChU0HDtGjuNa46YjXaxLOhH7/fxi6bjYcK0bJiOos5XKL1DuUnGIZe1FQRfWWJM5Q6wLf46J1bIuIpRb2mJHl0JrpiB1Pqz3+hGbEh4fxkPaaWRTiZic46+4Ud03YOTM/YkckuIihDCQ1BTyv1z16WiEfyvzt0KkQmvL1
 U5Pkc6sb
 Rl7brhS3PBdsLzQW4I0QdMfN2UWD2hb4kpeFHbidY2PYC8RngvwtMefioYqvMUNH71Z9s40oC1xUsLYmTMr+WKbc4l9y/2MeUiAL61w4b6n8osSZqC2zcuUNcExRGMM7kINL3TnJyHyAtOancBatHxH1vh/2R03hj5Htcbc45XhECS4+G9VP+Bix2rNmkcs9Tnt7I5lDvcPqv3jFdcAT2+yW6fqHwHUWafI33ij2eS3rhFucRbbaAtTFy3mFnXKhkSrV/woYjHSs0OId6x9HmDY7hkMD3pAdbtpw34M/gquSgiHqO8aMxiXjWaGqtwpAHL/YC8hqTWZ9vIqNP8nmGhSfLqOgRtMicxFbaW2LorqcZ7PI84DxVVDPSMzrQCyxp/Zb8CtVvaM1CZotmMyj8i9aUE34UjJDe0VIf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 5:33 PM, David Hildenbrand (Arm) wrote:
> On 10/27/26 10:03, Baolin Wang wrote:
>>
>>
>> On 10/27/26 5:00 PM, David Hildenbrand (Arm) wrote:
>>> On 10/27/26 03:19, Baolin Wang wrote:
>>>> Ayush reported an issue that shmem/tmpfs folios are still mapped when
>>>> truncating them on production:
>>>> "
>>>> BUG: Bad page cache in process ...  pfn:...
>>>> page dumped because: still mapped when deleted
>>>> "
>>>>
>>>> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
>>>> branch, and I got the following crash info. From the dump message, we can
>>>> see that truncate_inode_folio() is really trying to remove mapped folios,
>>>> which is incorrect.
>>>>
>>>> "
>>>> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
>>>> index:0x3880 pfn:0x191647
>>>> [  189.171995] memcg:ffff0000cc073d40
>>>> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
>>>> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
>>>> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
>>>> .......
>>>> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
>>>> [  189.172026] ------------[ cut here ]------------
>>>> [  189.172027] kernel BUG at mm/filemap.c:155!
>>>> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>>> .......
>>>> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
>>>> 7.3.0-rc4+ #277 PREEMPT(lazy)
>>>> .......
>>>> [  189.183986] Call trace:
>>>> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
>>>> [  189.184391]  __filemap_remove_folio+0x34/0x160
>>>> [  189.184633]  filemap_remove_folio+0x4c/0xb0
>>>> [  189.184859]  truncate_inode_folio+0x34/0x58
>>>> [  189.185087]  shmem_undo_range+0x220/0x658
>>>> [  189.185308]  shmem_fallocate+0x2f0/0x470
>>>> [  189.185527]  vfs_fallocate+0x128/0x328
>>>> ......
>>>> [  189.187078]  el0t_64_sync+0x184/0x188
>>>> "
>>>>
>>>> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
>>>> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
>>>> MADV_DONTNEED synchronously releases the pagetable page before calling
>>>> tlb_flush_rmaps(), this could cause another thread's truncation to skip
>>>> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
>>>> as non-zero. A possible race scenario is as follows:
>>>>
>>>> CPU 0                           CPU 1
>>>> shmem_fallocate                 madvise_dontneed_single_vma
>>>>     unmap_mapping_range            .......
>>>>     ......
>>>>     (filemap_map_pages() remap folios)
>>>>                    zap_pte_range
>>>>     truncate_inode_folio            zap_empty_pte_table(pmd clear)
>>>>       unmap_mapping_folio
>>>>       ......
>>>>         zap_pmd_range (saw pmd none, skip)
>>>>
>>>>     filemap_remove_folio
>>>>       BUG_ON(folio_mapped)
>>>>                                       tlb_flush_rmaps(remove rmaps)
>>>>
>>>> To fix this issue, we should move the pmd clear operation (via
>>>> zap_empty_pte_table())
>>>> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
>>>> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
>>>> without holding the PTL, the folio's mappings are guaranteed to have been
>>>> removed via tlb_flush_rmaps().
>>>>
>>>> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
>>>> Reported-by: Ayush Ranjan <ayushr@modal.com>
>>>> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
>>>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
>>>> madvise(MADV_DONTNEED)")
>>>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>>>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>>>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>> Changes from v4:
>>>>    - Put the pmd_none() check in the 'else if' branch (per David).
>>>> Changes from v3:
>>>>    - Collect review tags from Qi, Pedro and Lorenzo. Thanks.
>>>>    - Update the related comments per Lorenzo.
>>>> Changes from v2:
>>>>    - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per
>>>> David).
>>>> Changes from v1:
>>>>    - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
>>>> ---
>>>>    mm/internal.h | 10 ++++++----
>>>>    mm/memory.c   | 30 +++++++++++++++---------------
>>>>    2 files changed, 21 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/mm/internal.h b/mm/internal.h
>>>> index b1b0f29d2216..ffb8eaec90e3 100644
>>>> --- a/mm/internal.h
>>>> +++ b/mm/internal.h
>>>> @@ -584,14 +584,16 @@ void free_pgtables(struct mmu_gather *tlb, struct
>>>> unmap_desc *desc);
>>>>    void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>>>>      /**
>>>> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
>>>> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>>>>     * @mm: The mm_struct.
>>>>     * @pmdp: Pointer to the pmd that was found to be pmd_none().
>>>>     *
>>>>     * When we find a pmd_none() while unmapping a folio without holding the PTL,
>>>> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
>>>> - * indicate that it's unmapped. Skipping the PMD without synchronization could
>>>> - * make folio unmapping code assume that unmapping failed.
>>>> + * zap_huge_pmd() may have cleared the PMD but not yet updated the folio
>>>> + * mapcount, and zap_empty_pte_table() clears the PMD only after the rmaps
>>>> + * for the table have been removed, but nothing orders the pmd_none() read
>>>> + * against later mapcount reads. Skipping the PMD without synchronization
>>>> + * could make folio unmapping code assume that unmapping failed.
>>>>     *
>>>>     * Wait for concurrent zapping to complete by grabbing the PTL.
>>>>     */
>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>> index e911e63ba1ed..d9c54549b85b 100644
>>>> --- a/mm/memory.c
>>>> +++ b/mm/memory.c
>>>> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather
>>>> *tlb,
>>>>            }
>>>>        } while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>>>>    +    add_mm_rss_vec(mm, rss);
>>>> +    lazy_mmu_mode_disable();
>>>> +
>>>> +    /* Do the actual TLB flush before dropping ptl */
>>>> +    if (force_flush) {
>>>> +        tlb_flush_mmu_tlbonly(tlb);
>>>> +        tlb_flush_rmaps(tlb, vma);
>>>> +    }
>>>> +
>>>>        /*
>>>>         * Fast path: try to hold the pmd lock and unmap the PTE page.
>>>>         *
>>>> @@ -2043,18 +2052,12 @@ static unsigned long zap_pte_range(struct mmu_gather
>>>> *tlb,
>>>>         * to hold the pmd lock failed, then we need to recheck all pte entries
>>>>         * to ensure they are still none, thereby preventing the pte entries
>>>>         * from being repopulated by another thread.
>>>> +     *
>>>> +     * Clear the PMD after the rmaps for the table have been removed, in case
>>>> +     * an incorrect mapcount is observed after unmapping the folio.
>>>>         */
>>>>        if (can_reclaim_pt && direct_reclaim && addr == end)
>>>>            direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>>>> -
>>>> -    add_mm_rss_vec(mm, rss);
>>>> -    lazy_mmu_mode_disable();
>>>> -
>>>> -    /* Do the actual TLB flush before dropping ptl */
>>>> -    if (force_flush) {
>>>> -        tlb_flush_mmu_tlbonly(tlb);
>>>> -        tlb_flush_rmaps(tlb, vma);
>>>> -    }
>>>>        pte_unmap_unlock(start_pte, ptl);
>>>>          /*
>>>> @@ -2102,12 +2105,9 @@ static inline unsigned long zap_pmd_range(struct
>>>> mmu_gather *tlb,
>>>>                    continue;
>>>>                }
>>>>                /* fall through */
>>>> -        } else if (details && details->single_folio &&
>>>> -               folio_test_pmd_mappable(details->single_folio) &&
>>>> -               next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
>>>> -            sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>> -        }
>>>> -        if (pmd_none(*pmd)) {
>>>> +        } else if (pmd_none(*pmd)) {
>>>> +            if (details && details->single_folio)
>>>> +                sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>>                addr = next;
>>>>                continue;
>>>>            }
>>>
>>>
>>>
>>> } else if (pmd_none(*pmd) && details && details->single_folio)) {
>>>      sync_with_folio_pmd_zap(tlb->mm, pmd);
>>> }
>>>
>>> if (pmd_none(*pmd) {
>>>      addr = next;
>>>      continue;
>>> }
>>>
>>>
>>> Minimal change required, no?
>>
>> No, keeping two pmd_none() checks cannot fix the race, as I replied before. [1]
>>
> 
> Best to wait to submit new versions if there are open discussions? Because now
> we have the same discussion in two places.

Sure.

> 
> I think you're right about the race, the issue is that we check for
> pmd_is_huge(), not pmd_present() which confused me.
> 
> Clearest to me would be to not drop the second pmd_none() check but move it
> where it belongs: if splitting zapped the PMD.
> 
> @@ -2101,13 +2104,15 @@ static inline unsigned long zap_pmd_range(struct
> mmu_gather *tlb,
>                                  addr = next;
>                                  continue;
>                          }
> +                       /* We already synchronized with concurrent zapping. */
> +                       if (pmd_none(*pmd)) {
> +                               addr = next;
> +                               continue;
> +                       }
>                          /* fall through */
> -               } else if (details && details->single_folio &&
> -                          folio_test_pmd_mappable(details->single_folio) &&
> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
> -                       sync_with_folio_pmd_zap(tlb->mm, pmd);
> -               }
> -               if (pmd_none(*pmd)) {
> +               } else if (pmd_none(*pmd)) {
> +                       if (details && details->single_folio)
> +                               sync_with_folio_pmd_zap(tlb->mm, pmd);
>                          addr = next;
>                          continue;
>                  }

IMHO, I'm not a big fan of adding two pmd_none() checks just to avoid an 
uncommon concurrent sync. If you don't like the approach in v4 [1] 
either, I'll follow your preferred coding style.

@@ -2102,12 +2105,11 @@ static inline unsigned long zap_pmd_range(struct 
mmu_gather *tlb,
  				continue;
  			}
  			/* fall through */
-		} else if (details && details->single_folio &&
-			   folio_test_pmd_mappable(details->single_folio) &&
-			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			sync_with_folio_pmd_zap(tlb->mm, pmd);
  		}
+
  		if (pmd_none(*pmd)) {
+			if (details && details->single_folio)
+				sync_with_folio_pmd_zap(tlb->mm, pmd);
  			addr = next;
  			continue;
  		}

[1] 
https://lore.kernel.org/all/4cc521a118564b4145edf0324066ab532fb41181.1792979870.git.baolin.wang@linux.alibaba.com/#t

> Removing the "if (pmd_none(*pmd)) {" in your variant is what confused me,
> because it looks like we no longer happen the case where we zapped the PMD
> ourselves.

Because zap_pte_range() will return the same addr and check the none PMD 
again in zap_pmd_range() in this case, I thought you wanted this simple 
version, considering keeping two pmd_none() checks is incorrect.

