Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A70DED47CA4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 01:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BB16B0005; Thu, 15 Jan 2026 20:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A0A6B0088; Thu, 15 Jan 2026 20:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E247C6B0089; Thu, 15 Jan 2026 20:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFC286B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:03:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC4761AE65A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:03:43 +0000 (UTC)
X-FDA: 84336029526.06.6D49212
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B20340015
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:03:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CbGdHJjA;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768525422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bKL4mnAg97J1S0u6/QixAAbKrjY7AjKN002xrKUlnM=;
	b=ZgHdPZ1jSRKWBKqp6U27RKYFlAq84xYoiH+ct1aiU66TxS4II3w4t5D6l8pMEvvZkwT0JR
	gSI+FfJz0Rm/t3JCaCINuWnofq1W5UpMF51Fc3No7MZ7CfKBYtCAj0dZFXUC1rVCLSNAqs
	Q9g6br/82Z5/wxuSNkk28FAO7EuDDHw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CbGdHJjA;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768525422; a=rsa-sha256;
	cv=none;
	b=znz/FBKNG/UNA8eDA0ILzd4IIcyfFNZLO5LAqKYASZYTp+4B6X3FxPiw3DOWrZNDpk6+y2
	95mo8hy6IjuvbfEpsXOs2DfZrjp02KTP81G0p2LhTZJpKIqFSiN4tZ/nachrsQgJ9KLl1Q
	jtIPAh0bji7UhJKE/KjVeo/NA+tQQ98=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768525416; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0bKL4mnAg97J1S0u6/QixAAbKrjY7AjKN002xrKUlnM=;
	b=CbGdHJjAR6ynSJJc+LGxrKKGyxXC2BXq2FHVIlYWAahObCImY7tJdxGU2J2xUTCIOHu3NNVJEPSnJHtLgbQMjrs5owZGCNUpUPcPkRvDVg3dt6PMo8DgFbad2Zi/RgMfe7kLuwXLChbYay4OvHiRyU9jyJOZ6kLWmoDmRNkL2EY=
Received: from 30.251.17.19(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wx8.qXO_1768525413 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Jan 2026 09:03:35 +0800
Message-ID: <26cb8bfa-67a7-43d8-b431-a3307df3e559@linux.alibaba.com>
Date: Fri, 16 Jan 2026 09:03:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out
 from under PTL
To: Lance Yang <lance.yang@linux.dev>
Cc: ioworker0@gmail.com, lorenzo.stoakes@oracle.com, david@kernel.org,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "hughd@google.com" <hughd@google.com>
References: <20260115071651.42626-1-lance.yang@linux.dev>
 <0bc3807e-2c1b-43af-9aab-665ce30d49d4@linux.alibaba.com>
 <8754b56d-b9a8-4b94-b5bc-982384234527@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8754b56d-b9a8-4b94-b5bc-982384234527@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3B20340015
X-Stat-Signature: cj57n5k8wtdi7i6d199p1ooa4qnh5mi1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768525419-889134
X-HE-Meta: U2FsdGVkX1/HFicJU5M+P7Yhgv48cqSG4GUwuJ+/EvSrNgzfaKBbAxueVLbBWrXLs5Fe23Ch9px/jhc3rHH7BD6yRnm7yq1ema+8uvD5No+aEbwNyBAQCGu/Nh0UCXdoh7Mjl5xKp58YSfmtCeJxeCZayKvEU4th1fWw/HbgsTW7Ls95AWxzLL6x8rc/P2xzURn2lR/qB98S73J5TS5lbv/VjiL45uXIysH/7Zhy+0xcmUuZgJbj9VtIysTVICXaFhHwfCGm5BEKLCgtTu2K/GIaXZoXODRdQ3JJsvMsyMp4oi56+B7JosOiu+tbU5C5G0JRiQ4MQIx2T3pHIfzHGr422DwU4Cu3rJDSe8tjhWha/WwaP4kDGNNH7V3FjyJISsNqRnJsiWXeoFsFrPXTYnjlTArnSggO3/BtFZQyXeK/+ofSNIxhV6F2U8APn/lof+nvWcXsoU6WKmb73Q2BXb8E3EXoZWrcYK8i05QhUI5xBBCA40OPe8akTBiJfunLiO+Gz1nfNYDGV1CIDg1SZUAcWUFFwr3z32gMlrHeNxUstgKox84/c1Mf5bWBH9OQzzEQJlIHJclGYi+C4/ACSMms+qlfyOe3ymYrnpbd3BL8zew36HjqF1J13EPyxbATeDaFLy81cCsadVj/O7JWKmGlTavXeLi+FKlMziZGw9dGUi5LWPkJdMSw8lnwRKq9YC5l4en/lvOhE0z3nmc/ZKtk1AKqFtVYcQlxtx2FWVbKtnhSRZnEejQjZ2MpWd+0w0VqhLkTYnYuWAu6GVcks7HTUTA63hkT4nC4m4pPak0LJcFaC7U6W2KtYkH6H47/dPvB0+IjlZqRy19QbZnbnn080ETIYXO1xsrHBgec+rMb52iIGeet+g5tkK7aEniSH6GBjgdBb4epu91dSeKjwrtb13Iy4iIVi/wsVoWr+WGHFOxC85kAKYq6bx6ry1Bz/j2mIHXEA5/N1wXSw+n
 nk1gKBtH
 S8W1Q8wpg8CZ1pKWCgo1AgTMuGf2nf5TF+3Zg5/bkiNyhvSE7gNtfmHHr1T8TSYy+lLoLOt06Lc1t3uicuAwAxI/0AE2llrRQN1Xh9vChjU9civaLN8nrJIeDr0wjhmKGLhiOL5TtFifoEC4O1Ysi2NZ7tHp2ramUbs2LGCfh9dURYISuyw1tep4by/V7R7KZEnjLtkDLjMOxiiwr2uwmRIA1W28EwxZJyP8fMuj6tPuumEBUg3yI2uzxqrjojp/hHqVuaPPtRw9FahZWjAA+k7ysYvC0BVCgCnTS1wkrWLq/athnvrN/mFAWCDgmj1zQo77CQpRNTTwdw3ViG2tUUVWIoCQO9ats7X+QWw/w0BrOQz4Q10mCspzIioWFxjo4V9cHm7706+gG0rE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/15/26 8:28 PM, Lance Yang wrote:
> 
> 
> On 2026/1/15 18:00, Baolin Wang wrote:
>> Hi Lance,
>>
>> On 1/15/26 3:16 PM, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
>>> which we really don't want to do while holding PTL.
>>
>> Could you add more comments to explain why this is safe for the PAE case?
> 
> Yep, IIUC, it is safe because we've already done pmdp_collapse_flush()
> which ensures the PMD change is visible.
> 
> pmdp_get_lockless_sync() (which calls tlb_remove_table_sync_one() on PAE)
> is just to ensure any ongoing lockless pmd readers (e.g., GUP-fast) 
> complete
> before we proceed. It sends IPIs to all CPUs and waits for responses - a 
> CPU
> can only respond when it's not between local_irq_save() and 
> local_irq_restore().
> 
> Moving it out from under PTL doesn't change the synchronization semantics,
> since lockless readers don't depend on PTL anyway.

Cc Hugh who introduced the pmdp_get_lockless_sync(), to double check.

Sounds reasonable to me, please add these comments into the commit 
message. Thanks.

>> For the non-PAE case, you added a new tlb_remove_table_sync_one(), why 
>> we need this (to solve what problem)? Please also add more comments to 
>> explain.
> 
> Oops, you're right, the original macro was a no-op for non-PAE.
> 
> I should just move the macro call out from under PTL, rather than
> replacing it with direct tlb_remove_table_sync_one() calls.

OK.

>>> Just move the call to after we release PTL, and drop the macro wrapper
>>> while we're at it.
>>>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>   include/linux/pgtable.h | 4 ----
>>>   mm/khugepaged.c         | 5 +++--
>>>   2 files changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index eb8aacba3698..fb04ed22052c 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>>>       return pmd;
>>>   }
>>>   #define pmdp_get_lockless pmdp_get_lockless
>>> -#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
>>>   #endif /* CONFIG_PGTABLE_LEVELS > 2 */
>>>   #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
>>> @@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>>>   {
>>>       return pmdp_get(pmdp);
>>>   }
>>> -static inline void pmdp_get_lockless_sync(void)
>>> -{
>>> -}
>>>   #endif
>>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 9f790ec34400..0a6cebf880e0 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1664,10 +1664,10 @@ static enum scan_result 
>>> try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>>>           }
>>>       }
>>>       pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
>>> -    pmdp_get_lockless_sync();
>>>       pte_unmap_unlock(start_pte, ptl);
>>>       if (ptl != pml)
>>>           spin_unlock(pml);
>>> +    tlb_remove_table_sync_one();
>>>       mmu_notifier_invalidate_range_end(&range);
>>> @@ -1818,7 +1818,6 @@ static void retract_page_tables(struct 
>>> address_space *mapping, pgoff_t pgoff)
>>>            */
>>>           if (likely(file_backed_vma_is_retractable(vma))) {
>>>               pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
>>> -            pmdp_get_lockless_sync();
>>>               success = true;
>>>           }
>>> @@ -1826,6 +1825,8 @@ static void retract_page_tables(struct 
>>> address_space *mapping, pgoff_t pgoff)
>>>               spin_unlock(ptl);
>>>   drop_pml:
>>>           spin_unlock(pml);
>>> +        if (success)
>>> +            tlb_remove_table_sync_one();
>>>           mmu_notifier_invalidate_range_end(&range);
>>


