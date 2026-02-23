Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99865EA4FC8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62C56B0005; Mon, 23 Feb 2026 09:25:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AE56B0088; Mon, 23 Feb 2026 09:25:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C5E6B008A; Mon, 23 Feb 2026 09:25:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0556B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:25:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 335E31A0194
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:25:03 +0000 (UTC)
X-FDA: 84475943286.23.0E52A16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B53612000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:25:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVgAu2oV;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771856701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xdOagrBIg4dvD6q1CWhspgQRYO+GhmG0xuz9aATqI8=;
	b=OKC0gq7dqywJc2SOx5rA5WGhNDj/lhJz9RdYewYdCp/CL5m+6m8q2f7k2J3lLggVBtR4Oj
	oCmf7aQy0I0rBovo8Tor1C181DpDs8kQd0TK5WtyXc/xSdBDha1tuACWKg7q6KcjVmCdir
	2WZAke7qXCs+4NZpj0L0bwjZwk774WQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771856701; a=rsa-sha256;
	cv=none;
	b=BZPsUfjKxLMOBwsO3QQfPMbUq+LJhRcdE4I1rBmkGnifOTNEYqffwBluNHOS0yDBk/4lIu
	/vLOLB8sx9berEn3utIhEnp3QE+lodzNlODHyE2P2Ps5ii+eG9gCMqu8vH6nEGkhR9iTB4
	HaW2dQOY8OG2LQIDEYxO5vaAtpEmMH4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVgAu2oV;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AF0260018;
	Mon, 23 Feb 2026 14:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB18C116C6;
	Mon, 23 Feb 2026 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771856700;
	bh=KL50oxwSnSFSLfveHD3UAeOlUZdncge2TRX2ejJiVH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dVgAu2oV8RxtKTfoQ9wm2FfI8M1EtY/t8VfbAGkYmk9A9Yrs/xCZ70NUU8nUV6PeX
	 IYkCzTqB0P27FGX5dfvW0aO1kNWuJ5kyMXf9Myi//1RrTqA+HSf1ovPBttquKC0UFH
	 3hc2rNIBpM5TBcwV/Ol7WYuxfnnLqvwuLXj4znPqnkW1lY9/aaaJPtnNtO1hAzIAKn
	 EXqnZVFSR4aA8UGujagcrA4mplEr56RAzbWytGVMu+lJlGs7vGGLPnwTAwAUZLDmum
	 CGz2MNSjklr75HK+BECxBA7qr41Z+a/5do2gq+6Wa6F79ClNU5xQ218RL6sS9Wu38G
	 SfO0/Ky42i6HA==
Message-ID: <62d53608-ed7b-42fe-baad-3023764383a3@kernel.org>
Date: Mon, 23 Feb 2026 15:24:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022512.19076-1-npache@redhat.com>
 <164bfaf0-5e8a-4bd2-a04c-93d61856a941@kernel.org>
 <CAA1CXcCA6HN_Y4npsH==6tbCJbtMR=+OBmRWowb5NmficZdcHw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCA6HN_Y4npsH==6tbCJbtMR=+OBmRWowb5NmficZdcHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B53612000B
X-Stat-Signature: swpfzszfn47157go443jz4e77hm5an64
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771856701-115222
X-HE-Meta: U2FsdGVkX18EhTsbnBHrg+3OM0hPncByQDxl4L3lGVjLDuXpcROQziamNmElrQeFqVLqoZ/1y21wW0TPLFMX6nef7kvv3SxOIXX7en4MklpXvvEI+2Z5mlKUcVhn/sYP0ie2Pxg56zN8ifeX0QtFYUCtfE/Wlre5mGnv/qkcT4Ma2EvgAPVPqcqdfS4VA+uxYtRdM3Z4N7ummaHJfax2ioSaZkjDocTLlLVoQC+X6ZupKx2rGHNTnc0hWBDV/DrPqBndhQBNAqqUa5PJSrP3NlS22ye/JyI1B3UwvljK63BD0NBvQbR1g9/hlJrUisdL2OBQo2TxWqKdi8Ndeil27WwJzTtc6+tOEnhp+bixzx4AqZ1WnpRoxBg9nqdZtRyKKhjZ4gr32qCzRutb550+4WKNiU42UnrLrhQ45Cip2zam/7iYf2G0YX9JFl4DX2R1vz3eyyEmaBTBODCy3VemL6Ny2o5X7eQQ1c4uj5oz5N5P1Sc9rBFCgmOgwHJNB6ZWOAlXXZMQsPIk/N/5XnanVm1+UsgJwuAmfyOZhPfnxchYRSbpo3gTfs2YoLD86Fan3QCT9GIW00kXkKg5ULGrQGFRkz27n82pSScyOKZU6cXfr/GGgVgYtru6Fde3MMHsGaAaq5QbSXN5YuuXsNSFN7mYcaJbKDMd7uXDowjU66yPlyQOlmADVv/JL2y6CIwRyaqiNwR7jieCtU/uB4p7CEi1eu6WyZ1UO67WsguWFsDKfj5SUxlXZDjCLqsz0WwhQsV93t47diz9H/zJAbwtvJX6tn966K2qR6bGaDr4lF9noOl7aJmqrGHzyz6CokJLXKGGGXpC/QHKbC1VBV/Ng7qTqevunHn0suoUULf6k2PML98dsY+PkiJe5PkJvT6fh9QwL3yCVVyZBdFOyeAM25t0m3FvzgMzky5A7A8uneHT/Yp7zANW9mGyvmo85NE4RIKy6fxmxKVgJx0yO/R
 EW6XNQkr
 yD5T+YWSVgjq4dRFhJxF7ZDTExe4YxeY1vp3nJqLssq3OPFZTQ3En6kVZL6GnapG+iVUxXVFGfS6HIIXoFwfIxwsW88SJDGgZKvJ+te2LP2oGH7puxPltVG+sSgX9lIHZcTYlhOmkENGuZ5E8IBOihSH34mj3g5J8Er4FjwzfDkz2SfNzjqVruOnJePlryqWNKPEOU+NXV/GSB4hbdoqBuFZht4gS1rJ2lOEkKa6W4wtcwIdS+mSI0Rc/GsEznchDHER2Afwu8m7+TM/chGe7I3ZKrr6gFNMuHuxRhz6gpJHOk+xZzLslywEsRvsPMyeT3l+EWUAQns33ShqWQLKNQiR7KR6SI52a7WCkN+88vSVLNa5AB3Z3hZPtm8IzjaZoSjC4lDCY5nEPizkLHqqb7+NAQIxs87TjqSUsx/a+WpwyZ5rFY6Q3ZxuCyDt6iCk1CmyhnwMaCQ+FQCVNwciEpp7Azw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 21:26, Nico Pache wrote:
> On Thu, Feb 12, 2026 at 1:04 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/12/26 03:25, Nico Pache wrote:
>>> The khugepaged daemon and madvise_collapse have two different
>>> implementations that do almost the same thing.
>>>
>>> Create collapse_single_pmd to increase code reuse and create an entry
>>> point to these two users.
>>>
>>> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
>>> collapse_single_pmd function. This introduces a minor behavioral change
>>> that is most likely an undiscovered bug. The current implementation of
>>> khugepaged tests collapse_test_exit_or_disable before calling
>>> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
>>> case. By unifying these two callers madvise_collapse now also performs
>>> this check. We also modify the return value to be SCAN_ANY_PROCESS which
>>> properly indicates that this process is no longer valid to operate on.
>>>
>>> We also guard the khugepaged_pages_collapsed variable to ensure its only
>>> incremented for khugepaged.
>>>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>    mm/khugepaged.c | 121 ++++++++++++++++++++++++++----------------------
>>>    1 file changed, 66 insertions(+), 55 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index fa41480f6948..0839a781bedd 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2395,6 +2395,62 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
>>>        return result;
>>>    }
>>>
>>> +/*
>>> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
>>> + * the results.
>>> + */
>>> +static enum scan_result collapse_single_pmd(unsigned long addr,
>>> +             struct vm_area_struct *vma, bool *mmap_locked,
>>> +             struct collapse_control *cc)
>>> +{
>>> +     struct mm_struct *mm = vma->vm_mm;
>>> +     enum scan_result result;
>>> +     struct file *file;
>>> +     pgoff_t pgoff;
>>> +
>>> +     if (vma_is_anonymous(vma)) {
>>> +             result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
>>> +             goto end;
>>> +     }
>>> +
>>> +     file = get_file(vma->vm_file);
>>> +     pgoff = linear_page_index(vma, addr);
>>> +
>>> +     mmap_read_unlock(mm);
>>> +     *mmap_locked = false;
>>> +     result = collapse_scan_file(mm, addr, file, pgoff, cc);
>>> +
>>> +     if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
>>> +         mapping_can_writeback(file->f_mapping)) {
>>> +             const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>> +             const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>> +
>>> +             filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>> +     }
>>> +     fput(file);
>>> +
>>> +     if (result != SCAN_PTE_MAPPED_HUGEPAGE)
>>> +             goto end;
>>> +
>>> +     mmap_read_lock(mm);
>>> +     *mmap_locked = true;
>>> +     if (collapse_test_exit_or_disable(mm)) {
>>> +             mmap_read_unlock(mm);
>>> +             *mmap_locked = false;
>>> +             return SCAN_ANY_PROCESS;
>>> +     }
>>> +     result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
>>> +     if (result == SCAN_PMD_MAPPED)
>>> +             result = SCAN_SUCCEED;
>>> +     mmap_read_unlock(mm);
>>> +     *mmap_locked = false;
>>> +
>>> +end:
>>> +     if (cc->is_khugepaged && result == SCAN_SUCCEED)
>>> +             ++khugepaged_pages_collapsed;
>>> +     return result;
>>> +}
>>> +
>>>    static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *result,
>>>                                            struct collapse_control *cc)
>>>        __releases(&khugepaged_mm_lock)
>>> @@ -2466,34 +2522,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>>>                        VM_BUG_ON(khugepaged_scan.address < hstart ||
>>>                                  khugepaged_scan.address + HPAGE_PMD_SIZE >
>>>                                  hend);
>>> -                     if (!vma_is_anonymous(vma)) {
>>> -                             struct file *file = get_file(vma->vm_file);
>>> -                             pgoff_t pgoff = linear_page_index(vma,
>>> -                                             khugepaged_scan.address);
>>> -
>>> -                             mmap_read_unlock(mm);
>>> -                             mmap_locked = false;
>>> -                             *result = collapse_scan_file(mm,
>>> -                                     khugepaged_scan.address, file, pgoff, cc);
>>> -                             fput(file);
>>> -                             if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>>> -                                     mmap_read_lock(mm);
>>> -                                     if (collapse_test_exit_or_disable(mm))
>>> -                                             goto breakouterloop;
>>> -                                     *result = try_collapse_pte_mapped_thp(mm,
>>> -                                             khugepaged_scan.address, false);
>>> -                                     if (*result == SCAN_PMD_MAPPED)
>>> -                                             *result = SCAN_SUCCEED;
>>> -                                     mmap_read_unlock(mm);
>>> -                             }
>>> -                     } else {
>>> -                             *result = collapse_scan_pmd(mm, vma,
>>> -                                     khugepaged_scan.address, &mmap_locked, cc);
>>> -                     }
>>> -
>>> -                     if (*result == SCAN_SUCCEED)
>>> -                             ++khugepaged_pages_collapsed;
>>>
>>> +                     *result = collapse_single_pmd(khugepaged_scan.address,
>>> +                                                   vma, &mmap_locked, cc);
>>>                        /* move to next address */
>>>                        khugepaged_scan.address += HPAGE_PMD_SIZE;
>>>                        progress += HPAGE_PMD_NR;
>>> @@ -2799,6 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>                        cond_resched();
>>>                        mmap_read_lock(mm);
>>>                        mmap_locked = true;
>>> +                     *lock_dropped = true;
>>>                        result = hugepage_vma_revalidate(mm, addr, false, &vma,
>>>                                                         cc);
>>>                        if (result  != SCAN_SUCCEED) {
>>> @@ -2809,46 +2841,25 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>                        hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>>>                }
>>>                mmap_assert_locked(mm);
>>> -             if (!vma_is_anonymous(vma)) {
>>> -                     struct file *file = get_file(vma->vm_file);
>>> -                     pgoff_t pgoff = linear_page_index(vma, addr);
>>>
>>> -                     mmap_read_unlock(mm);
>>> -                     mmap_locked = false;
>>> -                     *lock_dropped = true;
>>> -                     result = collapse_scan_file(mm, addr, file, pgoff, cc);
>>> -
>>> -                     if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>> -                         mapping_can_writeback(file->f_mapping)) {
>>> -                             loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>> -                             loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>> +             result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>>>
>>> -                             filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>> -                             triggered_wb = true;
>>> -                             fput(file);
>>> -                             goto retry;
>>> -                     }
>>> -                     fput(file);
>>> -             } else {
>>> -                     result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>>> -             }
>>>                if (!mmap_locked)
>>>                        *lock_dropped = true;
>>>
>>> -handle_result:
>>> +             if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
>>> +                     triggered_wb = true;
>>> +                     goto retry;
>>> +             }
>>
>> Having triggered_wb set where writeback is not actually triggered is
>> suboptimal.
> 
> It took me a second to figure out what you were referring to, but I
> see it now. if we return SCAN_PAGE_D_OR_WB but the can_writeback fails
> it still retries.
> 
> Would be an appropriate solution if can_writeback fails to modify the
> return value.
> ie)
> 
> if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK) {
>      if (mapping_can_writeback(file->f_mapping)) {
>         const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>         const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> 
>         filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>      } else {
>         result = SCAN_(SOMETHING?)
>      }
> }
> fput(file);
> 
> we dont have a enum that fits this description but we want one that
> will continue.

I stared at the patch and possible ways to change it, but I wondered 
whether this refactoring is really the right approach.

The whole mmap locking just makes this all very weird.

Let me think about it some more.

-- 
Cheers,

David

