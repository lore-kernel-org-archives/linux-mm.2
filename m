Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C33CAF3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1291F6B008A; Sat, 11 Apr 2026 12:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1009B6B0092; Sat, 11 Apr 2026 12:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015EB6B0093; Sat, 11 Apr 2026 12:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27516B008A
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:08:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 996748C567
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:08:48 +0000 (UTC)
X-FDA: 84646758336.13.4115A8D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45711C000D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:08:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="R15M9uy/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775923726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0AQ6h5ILgndUXcvFDXdO8j0CBLbfIPjlPWsjfBpO2s=;
	b=LYdlIBQfzk4B/nfy4iyZooKzWNK3zwxyH9NS1hRYzV7iWR0xa9zmJgxBlU5HN+Lb5adOTz
	yMmFj9IIfGIYt+uChSClirQGEp7yzg36+oZCacOUmFn0LWo26i6zzVXH04a9daE5aWNPtW
	00/Pdu5+EB19zcR5KlfyOrRDf8E77nY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775923726; a=rsa-sha256;
	cv=none;
	b=MUzdEfiRexFfa64zonD7Dabg4XMly80/KC4UxiThgprE6sN4U+qxsmBSgGlxvathK0xE6/
	nQFDQj5fyKIyJIZrMtNih1X5rVmBfTLE9JIbod5276s3ocahnXPPKFRhi5Q92F81xRE3BZ
	HkTR31OJl77VxRNWoZPhBjrDfMK+kKE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="R15M9uy/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93F0A2A68;
	Sat, 11 Apr 2026 09:08:38 -0700 (PDT)
Received: from [10.163.141.179] (unknown [10.163.141.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 479703F641;
	Sat, 11 Apr 2026 09:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775923723; bh=FgB9t2z6USw7hVbVXkFXwPgw+4W6TEY8h/PvWm/9i2c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R15M9uy/mzzjDL05m4Jv+OX9L3X19RGD52hCgSrZBhdd9wHW/Un8lJ8D8QROuDnJz
	 mmpl5wAtQkd8BpP4UYPLqShrTdMyUYI9yXLa4h5d6hdL7V6rXEKbS+Fw2KUZE2WLY4
	 9DTJS4qSvASwyIgTHvC5c0FIIdwPPiAuSTQW/rlA=
Message-ID: <efe2a0da-a263-49ed-9bb4-ed1e8c2a3f27@arm.com>
Date: Sat, 11 Apr 2026 21:38:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
To: Jie Gan <jie.gan@oss.qualcomm.com>, akpm@linux-foundation.org,
 david@kernel.org, hughd@google.com, chrisl@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 riel@surriel.com, harry@kernel.org, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260410103204.120409-1-dev.jain@arm.com>
 <20260410103204.120409-3-dev.jain@arm.com>
 <2bfb7fd3-fc0c-47f7-8450-6180b0251ae5@oss.qualcomm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2bfb7fd3-fc0c-47f7-8450-6180b0251ae5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45711C000D
X-Stat-Signature: icwfgcufoapf6e7uokj1ikc7h15hp7m4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775923725-844301
X-HE-Meta: U2FsdGVkX1/f3TrCAh3xr0kNyKIPj4dg8YQ1DXfRQT77aGOjovvZ6g89F7ha5eJrox0/nQ1ype7DSb/rRa9kfXPQDFRi2FLf4h+69i0jtvnfEPOdRbVRaF5w3qgZj+Uc3TIRTzTWYDKH1FFg+DQKC5kM6+2QLYjRtqU0smmYTMGyljuNmHvx2I8ZUZi7FY9bT5M/xpUhASRigUEBrmQDQ279et+NIvh16aN+OHmrJ1vlPvUvrreQk1TVF3u9L7woRSUYGTeygQ1aIfJrkqRG4FmjNJpsLUE2rSYg5P4EV9H2w9GXPNQj1pFZIzcOtphG0t+X0zkJZpZ2FJfbPoUwAaJgEhspeYkJgGgT3/ToE8hdZ1EaQFYC+Hf3B9+J84dwF/S5/TVLS0OdaxqbKPSafYwal1w02JlbE4E9DdsyD/7Pn8PULedL7Dc2yhEpxCXjNudm+Eud5of3Htoqmi3lU/CDMGHr8uFOYVrp2MaNpXlxxVZiEkto8sNmfqZeJ6e+ts3OstBjVIbsnGr9Luf1wuUXWtgS2PBsHmocUA3Bo6ELcAV0lajhpRLoc/7mCuGKXTA7O90XeZ5/DmStJHW2uzoBTAW/hYl8IkrUWNaiF9dxSpUJfBxlfTuUXEZFpsLaMyLG2Rw/2HZGsWgm8nXXlWzMich7weZxr/9G5BI/XDDM5bjD1cLhFwYlisOsUfegGNXbL8UYSTmw4nrwD7ow3k4BVT/eCNN6yULe0H/t7IvsGPnqpUczxCQq8yA4mEE9y9u8WWq2KQRnQGTbELf4kdbHCkfIWNX0oW9zeBA8MMajnojV44tjuh7rtJuJC5MGFTE19j3IjXCkRM4A3ibdMFMA/Kt3cNzLdRUcAhTg88M9P/Oja4yv9KpimCevB9EkpD/x6aUulGwxAuK4DgQEnsqJE0z1XnRo1/z+FQu98sne6omXOOgU6OBWympTSkh99FIbbAnfnReq1YnKtz8
 s42vxqrW
 21h+WI9Mia7wF5bMiLH6ld7Uf07FbxroBq9m23ZN3R0vcDychMjMv9mYER1OR5L55fIcnKfskSgF3DvqRPpT2lVfCMNNTtPijS3pdnKrKrKTpgo/We0Usf16JjXyLP7wgNqe9CTxEHBpvAM6Phcu6gI0vXRmSuWyIBYOf3QEFy//ZkFj2irHXU3zqi6uPMwduXaErqQaZkc6g31UQG4BRlrAq+WBWP49jhnYkLlGaVJF5QK6el2GAWBGaYNaWOGizwjqtiVJYN0WLodojJArgJtIccnY45W/xZlIHQQg8RLyJ6Qfe9BRZG/2JADMm1UjTzAT2t4eZqrS3xEvbT5dUnItosebt1GALWAyk1AvUiB7Bk1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/04/26 5:15 pm, Jie Gan wrote:
> 
> 
> On 4/10/2026 6:31 PM, Dev Jain wrote:
>> Simplify the code by refactoring the folio_test_hugetlb() branch into
>> a new function.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   mm/rmap.c | 116 +++++++++++++++++++++++++++++++-----------------------
>>   1 file changed, 67 insertions(+), 49 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 62a8c912fd788..a9c43e2f6e695 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1978,6 +1978,67 @@ static inline unsigned int
>> folio_unmap_pte_batch(struct folio *folio,
>>                        FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>>   }
>>   +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
>> +        struct folio *folio, struct page_vma_mapped_walk *pvmw,
>> +        struct page *page, enum ttu_flags flags, pte_t *pteval,
>> +        struct mmu_notifier_range *range, bool *walk_done)
>> +{
>> +    /*
>> +     * The try_to_unmap() is only passed a hugetlb page
>> +     * in the case where the hugetlb page is poisoned.
>> +     */
>> +    VM_WARN_ON_PAGE(!PageHWPoison(page), page);
> 
> As you mentioned "No functional change is intended." in commit message, but
> you have changed VM_BUG_ON_PAGE to VM_WARN_ON_PAGE here?

Forgot to mention this in the description : )

... "While at it, as BUG_ONs are discouraged, convert them
to WARN_ON."


> 
>> +    /*
>> +     * huge_pmd_unshare may unmap an entire PMD page.
>> +     * There is no way of knowing exactly which PMDs may
>> +     * be cached for this mm, so we must flush them all.
>> +     * start/end were already adjusted above to cover this
>> +     * range.
>> +     */
>> +    flush_cache_range(vma, range->start, range->end);
>> +
>> +    /*
>> +     * To call huge_pmd_unshare, i_mmap_rwsem must be
>> +     * held in write mode.  Caller needs to explicitly
>> +     * do this outside rmap routines.
>> +     *
>> +     * We also must hold hugetlb vma_lock in write mode.
>> +     * Lock order dictates acquiring vma_lock BEFORE
>> +     * i_mmap_rwsem.  We can only try lock here and fail
>> +     * if unsuccessful.
>> +     */
>> +    if (!folio_test_anon(folio)) {
>> +        struct mmu_gather tlb;
>> +
>> +        VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
> 
> ditto
> 
> Thanks,
> Jie
> 
>> +        if (!hugetlb_vma_trylock_write(vma)) {
>> +            *walk_done = true;
>> +            return false;
>> +        }
>> +
>> +        tlb_gather_mmu_vma(&tlb, vma);
>> +        if (huge_pmd_unshare(&tlb, vma, pvmw->address, pvmw->pte)) {
>> +            hugetlb_vma_unlock_write(vma);
>> +            huge_pmd_unshare_flush(&tlb, vma);
>> +            tlb_finish_mmu(&tlb);
>> +            /*
>> +             * The PMD table was unmapped,
>> +             * consequently unmapping the folio.
>> +             */
>> +            *walk_done = true;
>> +            return true;
>> +        }
>> +        hugetlb_vma_unlock_write(vma);
>> +        tlb_finish_mmu(&tlb);
>> +    }
>> +    *pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
>> +    if (pte_dirty(*pteval))
>> +        folio_mark_dirty(folio);
>> +
>> +    *walk_done = false;
>> +    return true;
>> +}
>> +
>>   /*
>>    * @arg: enum ttu_flags will be passed to this argument
>>    */
>> @@ -2115,56 +2176,13 @@ static bool try_to_unmap_one(struct folio *folio,
>> struct vm_area_struct *vma,
>>                    PageAnonExclusive(subpage);
>>             if (folio_test_hugetlb(folio)) {
>> -            bool anon = folio_test_anon(folio);
>> -
>> -            /*
>> -             * The try_to_unmap() is only passed a hugetlb page
>> -             * in the case where the hugetlb page is poisoned.
>> -             */
>> -            VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
>> -            /*
>> -             * huge_pmd_unshare may unmap an entire PMD page.
>> -             * There is no way of knowing exactly which PMDs may
>> -             * be cached for this mm, so we must flush them all.
>> -             * start/end were already adjusted above to cover this
>> -             * range.
>> -             */
>> -            flush_cache_range(vma, range.start, range.end);
>> +            bool walk_done;
>>   -            /*
>> -             * To call huge_pmd_unshare, i_mmap_rwsem must be
>> -             * held in write mode.  Caller needs to explicitly
>> -             * do this outside rmap routines.
>> -             *
>> -             * We also must hold hugetlb vma_lock in write mode.
>> -             * Lock order dictates acquiring vma_lock BEFORE
>> -             * i_mmap_rwsem.  We can only try lock here and fail
>> -             * if unsuccessful.
>> -             */
>> -            if (!anon) {
>> -                struct mmu_gather tlb;
>> -
>> -                VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
>> -                if (!hugetlb_vma_trylock_write(vma))
>> -                    goto walk_abort;
>> -
>> -                tlb_gather_mmu_vma(&tlb, vma);
>> -                if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
>> -                    hugetlb_vma_unlock_write(vma);
>> -                    huge_pmd_unshare_flush(&tlb, vma);
>> -                    tlb_finish_mmu(&tlb);
>> -                    /*
>> -                     * The PMD table was unmapped,
>> -                     * consequently unmapping the folio.
>> -                     */
>> -                    goto walk_done;
>> -                }
>> -                hugetlb_vma_unlock_write(vma);
>> -                tlb_finish_mmu(&tlb);
>> -            }
>> -            pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
>> -            if (pte_dirty(pteval))
>> -                folio_mark_dirty(folio);
>> +            ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
>> +                          flags, &pteval, &range,
>> +                          &walk_done);
>> +            if (walk_done)
>> +                goto walk_done;
>>           } else if (likely(pte_present(pteval))) {
>>               nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
>>               end_addr = address + nr_pages * PAGE_SIZE;
> 


