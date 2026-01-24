Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6B9D7237A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 04:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742F36B0585; Fri, 23 Jan 2026 23:42:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0826B0586; Fri, 23 Jan 2026 23:42:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2CD6B0587; Fri, 23 Jan 2026 23:42:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDAF6B0585
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 23:42:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E6091AF544
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:42:21 +0000 (UTC)
X-FDA: 84365610882.26.3030E46
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 69D9180005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:42:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Is5GcrxK;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769229739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N28XyEumzJ4C6/nJsTg39lZr66Au6UdaMVxCJ6MAmKQ=;
	b=Rcl1Llr6A5IEaSKQ9MszXiTDru7vDt9PfrpdUkohAGNMEJuuF4XhYIKhKDjtkGHxHmzflL
	O7aTXn1ac1WqxUNkQKyWSENe4F81wwl1S4zu4/xP0VzPSLRE4ANI6rH8WNRlXuoz8r2qEH
	DloCebXmDkaAx06/lKukiJt+Qu+9vXA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Is5GcrxK;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769229739; a=rsa-sha256;
	cv=none;
	b=HLoMS71NeFgaNjLc2qw64sKx5xX4aphzhRezJ2I+YFGxBe2JWtGl/dE+sPQvDL7zSN3bXh
	krFNJmD0XCP5Xp1ecE7Iu0CUV5SrtQQPbNnckexBVed3E/2Kyy8e25jTmbFLhNzIED6vDj
	prxguTpgrlIdCXAdYO17671wESekSSk=
Message-ID: <34a68374-35d7-4d2f-9e2c-59a1c60c7ce7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769229735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N28XyEumzJ4C6/nJsTg39lZr66Au6UdaMVxCJ6MAmKQ=;
	b=Is5GcrxKYJfPEV1RcfsL1QZbOnEPGgEHB78T15sGHRwM4Kf6XxyRoDutWB3C4n1e+YANF3
	tt9TfDxaUgC/Ag/0WxEN7oJpPUzBA98goCBvqr9HnbULeF50VgLb2iE+LFn8Wowq81lKzd
	e6YUTley/tJXdCmZE1glISedRzPzl/o=
Date: Sat, 24 Jan 2026 12:41:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Content-Language: en-US
To: Nico Pache <npache@redhat.com>, "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
 hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, zokeefe@google.com, rientjes@google.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
 <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
 <CAA1CXcDm75=hM_g0x7ox05nGrGykE8ry_+NbryYu=T+TY114MQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAA1CXcDm75=hM_g0x7ox05nGrGykE8ry_+NbryYu=T+TY114MQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 1n6uoqgzdi73nx7a1ia31dh6wpis9gdp
X-Rspamd-Queue-Id: 69D9180005
X-Rspam-User: 
X-HE-Tag: 1769229739-3275
X-HE-Meta: U2FsdGVkX19SLx2Czu7YgQpZT1uJIgUHNxN4k/HNbaGhES37qJIBdPhnQhHCW8GCHZJqQN0At/G/4qi9+slaxj4rpHpsNTDTZ7AOrh0BSe0mzGB3UOdLWOIZV8gftlu58Ii5DF4CdQZqt2Ur5TumC7/1stZFu3MLpWfbPVwdE4jsZCkfbDuUt4X9nQWkj5D8Cw2Dm2F7nlTBLJCyZKkXTf20UNHE1+y7gjzqX3J7C/kBR4xaqi4pf1QdGZWgT8keR8XXyAMM12mfkL/18Zgel53t2mqFwxjXVcKKLaGIDBLOcGG194aiBRRTpsXI005qJi7bd7GA98AwlSRtQHESWygRtepv3NTZRdNvOhVnrrmIH/IjNI9hRRPUW01fL/mV2yxMEwGoJn9ZxoKg6CMMS5bgN53CHEW58jJYNwlzZuW9BAJ3WC8uyZFsIV9fUkNkVshA1PshlLELLOzqPmnA6cxEkYVhUNOF9BoDtXClBKCTYV6WeAC3O5K4256UANaqdlCHwmh/t3BZM93NaM72gjyWx822euZbib/GZrkdBB+g1wkK0DapMHUIcqmKxQCmKen+sf7JzB/v0KqLl9A2GNsP9lcMh0IcXLGieCOCZ+IpxUYJj02WB1PDjleDvlacVY5nKfoc+dWUwEsMlDnjkA4zHwAtuJrwJSdAtGWL6qsR3BzGYCbqKLgeXweoDgf+So60S90ru3mL81HmErayNnJGX79BVG0QehFNhTqAqHYd36x3etPyPZMINZjlSqAIDk/qPyvLZJNGFyyGpbDQxd5nBLSpQw17eHW6Q9TcWy5dLhPo3np6n9SW7c4f0ftu96elXdix4fcM9h6SKMBbwlmBgxx5QDNZsDWWCYJxmGgOZZWAICHeab5Fdhty2I44oEcnNRJvguhAJ/oD/z+iIuZrtdzWhRWN71CA+x/VX2xiVflnYR2TfWmOIraB1SGisOlrHxmEDbZ01/sG65R
 Vb8yvLyf
 kj1WizkIYoNdSXtka7IAMxiIUTmdGRR6ye6nsmjm7OkXVjRb1A3kGPr05HFJaQmwZqdE/3imQA7wkXcNpRtp/w3vAwbP9ye74sAWXJiuuAypGGeIVhU6QYnwioPO44D51GH+4Q9OcWr4hgcxVLerxY+SX3V50M4s2Hn5vV89ZTxZ7Aq3vh9ZPn4h35he6hykFj887g6x0cuaUqpAwPRSh7waBSW2DTQQshaicNGiHeNW9wgNQGKYtVQvBhpkkZuG97NlQFZshKW1bGvHvcj2JgHPVZlKXuxLxZ6ytzxAbwLiRLd6x/xWPDZNIJuqZtVr0zV8wqoNClqXH+EmBezL+/NKEzZ/ODi9M5Ec67u3qdmCcP0l3xlyrrAB0xZQVBjTaXbuw2uBhhuimQ8NdWePClrF6Ime6VPsBR//zQ3XUtPvagpOYIzo2nz8fmKw3lMnZWuLauD03Iuw8rve8idS4vpn3VxnWcGm3yHFI1k3F1TdpuVcTSGFlKGCQQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/24 07:26, Nico Pache wrote:
> On Thu, Jan 22, 2026 at 10:08 PM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>>
>> On 2026/1/23 03:28, Nico Pache wrote:
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
>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>
>> I think this patch introduces some functional changes compared to previous
>> version[1] ...
>>
>> Maybe we should drop the r-b tags and let folks take another look?
>>
>> There might be an issue with the vma access in madvise_collapse(). See
>> below:
>>
>> [1]
>> https://lore.kernel.org/linux-mm/20251201174627.23295-3-npache@redhat.com/
>>
>>>    mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
>>>    1 file changed, 60 insertions(+), 46 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index fefcbdca4510..59e5a5588d85 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2394,6 +2394,54 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm, unsigned long a
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
>>> @@ -2466,34 +2514,9 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
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
>>> @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>                        cond_resched();
>>>                        mmap_read_lock(mm);
>>>                        mmap_locked = true;
>>> +                     *lock_dropped = true;
>>>                        result = hugepage_vma_revalidate(mm, addr, false, &vma,
>>>                                                         cc);
>>>                        if (result  != SCAN_SUCCEED) {
>>> @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>                        hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>>>                }
>>>                mmap_assert_locked(mm);
>>> -             if (!vma_is_anonymous(vma)) {
>>> -                     struct file *file = get_file(vma->vm_file);
>>> -                     pgoff_t pgoff = linear_page_index(vma, addr);
>>>
>>> -                     mmap_read_unlock(mm);
>>> -                     mmap_locked = false;
>>> +             result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>>> +
>>> +             if (!mmap_locked)
>>>                        *lock_dropped = true;
>>> -                     result = collapse_scan_file(mm, addr, file, pgoff, cc);
>>>
>>> -                     if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>> -                         mapping_can_writeback(file->f_mapping)) {
>>> +             if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
>>> +                     struct file *file = get_file(vma->vm_file);
>>> +                     pgoff_t pgoff = linear_page_index(vma, addr);
>>
>>
>> After collapse_single_pmd() returns, mmap_lock might have been released.
>> Between
>> that unlock and here, another thread could unmap/remap the VMA, making
>> the vma
>> pointer stale when we access vma->vm_file?
> 
> + Shivank, I thought they were on the CC list.
> 
> Hey! I thought of this case, but then figured it was no different than
> what is currently implemented for the writeback-retry logic, since the
> mmap lock is dropped and not revalidated. BUT I failed to consider
> that the file reference is held throughout that time.
> 
> I thought of moving the functionality into collapse_single_pmd(), but
> figured I'd keep it in madvise_collapse() as it's the sole user of
> that functionality. Given the potential file ref issue, that may be
> the best solution, and I dont think it should be too difficult. I'll
> queue that up, and also drop the r-b tags as you suggested.
> 
> Ok, here's my solution, does this look like the right approach?:

Hey! Thanks for the quick fix!

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 59e5a5588d85..dda9fdc35767 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2418,6 +2418,14 @@ static enum scan_result
> collapse_single_pmd(unsigned long addr,
>          mmap_read_unlock(mm);
>          *mmap_locked = false;
>          result = collapse_scan_file(mm, addr, file, pgoff, cc);
> +
> +       if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
> +           mapping_can_writeback(file->f_mapping)) {
> +               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> +               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +
> +               filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> +       }
>          fput(file);
> 
>          if (result != SCAN_PTE_MAPPED_HUGEPAGE)
> @@ -2840,19 +2848,8 @@ int madvise_collapse(struct vm_area_struct
> *vma, unsigned long start,
>                          *lock_dropped = true;
> 
>                  if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
> -                       struct file *file = get_file(vma->vm_file);
> -                       pgoff_t pgoff = linear_page_index(vma, addr);
> -
> -                       if (mapping_can_writeback(file->f_mapping)) {
> -                               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> -                               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> -
> -
> filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -                               triggered_wb = true;
> -                               fput(file);
> -                               goto retry;
> -                       }
> -                       fput(file);
> +                       triggered_wb = true;
> +                       goto retry;
>                  }
> 
>                  switch (result) {
> 
> 
> 
> -- Nico

 From a quick glimpse, that looks good to me ;)

Only madvise needs writeback and then retry once, and khugepaged just
skips dirty pages and moves on.

Now, we grab the file reference before dropping mmap_lock, then only
use the file pointer during writeback - no vma access after unlock.

So even if the VMA gets unmapped, we're safe, IIUC.

[...]

