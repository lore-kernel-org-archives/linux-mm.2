Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFC4EF99E1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 08:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588406B0005; Sat, 14 Feb 2026 03:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536E26B0088; Sat, 14 Feb 2026 03:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438026B008A; Sat, 14 Feb 2026 03:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30A676B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 03:24:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C663C16077A
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:24:36 +0000 (UTC)
X-FDA: 84442375752.16.68B3278
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04E2212000A
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:24:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eMwD2COh;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771057475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0b3ePKb9h7s/bNBNK/TBkE8Sh0bASX5YD94TSCj3nQ=;
	b=keYVJeFc6h05Np4Dk7qjPRSry9J9Fv8lN5LfMm/GCePRRY0RKFzO5/PPMVBZNqp64BbkgE
	bopc4DPBcTjLNOjzO8jdvI0rSfPtJTpEZaBnkIXxpTll4fZEIuJNG57InbXLkLwftNypBm
	L4htTOdhoK0cBp+oMhMdk2rA/UvDTWE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eMwD2COh;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771057475; a=rsa-sha256;
	cv=none;
	b=x6eKnNyPPyB33ObQb1cCc6/3IZzDoiHggdX78jEyjxlFkR24r5aJhAa9/mgQ4Fyg1VKbcL
	MWE1cZ5/XDDn8jeRRY4ileIH3KwlsxDr3Vu9K2noY3jXgcDaqXxFkGITfY20cX4NyHaEuK
	969ZxQjfsQR9ToPPUm82JKHR6zQSX/A=
Message-ID: <baa203b1-496a-4f28-9619-40d380e5edb6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771057472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0b3ePKb9h7s/bNBNK/TBkE8Sh0bASX5YD94TSCj3nQ=;
	b=eMwD2COhEq5hwYku81uJdIue4IMojac5nDbd4/xP3hevp5u5wzAegtG41ViksjoBLnkmUM
	jLBtuLreVEZYW1KvxDqMFRDRF1J6XzMwSjgbpN5GTGPsDX3asJdr8IBuSg5RuhyQCfCS0p
	GBkTCUroacZ7n/5wIP7ALvNvWE6OdAs=
Date: Sat, 14 Feb 2026 16:24:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Content-Language: en-US
To: Nico Pache <npache@redhat.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212022512.19076-1-npache@redhat.com>
 <164bfaf0-5e8a-4bd2-a04c-93d61856a941@kernel.org>
 <CAA1CXcCA6HN_Y4npsH==6tbCJbtMR=+OBmRWowb5NmficZdcHw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAA1CXcCA6HN_Y4npsH==6tbCJbtMR=+OBmRWowb5NmficZdcHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 04E2212000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 1rzb8enbp7zuehskwtdf1am1qx5ee9ax
X-HE-Tag: 1771057474-455043
X-HE-Meta: U2FsdGVkX1+wC/52swVAAMikg9B/3PKNlxiDvu3eNMXK5Rn9h3JsifZu6oKGBWP2mAJ49poLsHUmRw2MtvqXqw3hrro1LVTTBa89x/Fl+HzI12aBKzLAfdImPiRkjcbVuE+ju9CutscDPK7S71INHf8gYmLbT6zu5LzJ0NVD86sM3pHU5clUPh1vYbc5riRwvB+gRFKdsnDLBBNzrSLl0RY6F5TTc9qe0FJg9ixe4Qk8dusUuY3UFmq8pA8z8r0PXKDZ4HjE/olyGzsXPhx0h7RsLI7m6sIaDachItaspMoM0vf52rT5Qw95J6r+g23Tt8H6EpenRSJK1fwGHXgJYvhmCAAwaMo+U1iU1xHk8uh7zs3LW5l+iXLfC2VUnFl8o+JsI3+CwI7KC5oewvzx+mBKjHmM/CWczSRgQj0J3kvXK2azKBUDHbs2//0E3c07JYCm7hWXxq6WhoFV7uGxfP/aS8JNClhJzsJn7FtF5prKPH+vTi2OOTT/umB5+IWT9ebr2yn51iVPObtpvOozc4YgzUrE4t72dMrBa79+Cq5+p9LQ0j51bDdhpNEYpTDZOWNknSmJrw7JahSZXbqjsrlIIrhVHWHya84XnfpqETTz7qpx86HfaxdFT9QMk0/oFRpjRyYeCG6V0tQRHhnADJ6iVvczq5UQxANDRvL7qZsNvSb/CSNsYnybfqPODNgv+O9oL8XV7OoRYL7Is5XV+VqjJHQgu39TXYGQ87gmKhsEnkZ4fhj1S5aXble6z1XPdWU+hsPzHpC28BJZZTW1g2dQ6OC/PNBKPCMS9pt8IfnfXC+2JCaC+LdzTieR6UHFnk31Slwe4Fp7EyGLsSpu6/s/YePyAHK8wCwVpVb8q+VFgIYVRAFElGxFfEkGv36D8qEk4ja5O2w45XnsRgDTmTtoLopyHVU7Zd7ArWEF1hMMdGepIOS6EBRMkoLV2DGo7aLGDQrdOVBJjZnA8++
 /OZk33JA
 wVEL32NinbOvXLog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/13 04:26, Nico Pache wrote:
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

Good catch!

> 
> It took me a second to figure out what you were referring to, but I
> see it now. if we return SCAN_PAGE_D_OR_WB but the can_writeback fails
> it still retries.
> 
> Would be an appropriate solution if can_writeback fails to modify the
> return value.
> ie)

Yep, we're on the right track. IIRC, David's concern has two parts:

1) Avoid retry when writeback wasn't actually triggered
    (mapping_can_writeback() fails)
2) Avoid calling filemap_write_and_wait_range() twice on retry

The proposed approach below addresses #1, but we still need to tackle #2.

The issue is that on the retry, collapse_single_pmd() doesn't know that
writeback was already performed in the previous round, so it could call
filemap_write_and_wait_range() again if the page is stil dirty.

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
> 
> Cheers!
> -- Nico
> 
>>
>> And you can tell that by realizing that you would now retry once even
>> thought the mapping does not support writeback (
>> mapping_can_writeback(file->f_mapping)) and no writeback actually happened.
>>
>> Further, we would also try to call filemap_write_and_wait_range() now
>> twice instead of only during the first round.

Right. Let's avoid calling it twice.


Cheers,
Lance

