Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0C9D7235E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8654C6B0492; Fri, 23 Jan 2026 04:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84FF36B0494; Fri, 23 Jan 2026 04:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F7A6B0495; Fri, 23 Jan 2026 04:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 635966B0492
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:31:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 061F98B853
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:31:28 +0000 (UTC)
X-FDA: 84362710698.21.593F702
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 60A1840014
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:31:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V5Ac+VrA;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769160687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/xyTpIGA3LTDEVDvOpXmC85+4HpEgmpDuugKSvZEtY=;
	b=z3Slye7wiKJ62RjLdbKNcmErGsJoeWyzOHvU3OPlsCSHNGovH7KDoLhYLpzAzD9guRrEeo
	QVXfOOuo9x0JEsAWND26sJbvR/INFCIqfCA4DGVlA2CE76pntJ9WLpM3GCJmTGSNznZc2h
	2UOYKUJz24DwedPGVw8rjE0sbKXtAVU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V5Ac+VrA;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769160687; a=rsa-sha256;
	cv=none;
	b=h1FmZ0yQc0OzO+BbzYF/TIXRubE0B9vu40Hkfx/ITjjSm/O90oZgiLdIVDigKOm48GUGsa
	wC45A4Dw/i218/xBaBBlYuJMWhrpJ6TcslNAuCtuVvgvdta/nhQsvq8YpjRnn7g/Y0jYjr
	vLK7DN9qwfQvLNy4qo0YRnHxBKHzk3Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769160682; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n/xyTpIGA3LTDEVDvOpXmC85+4HpEgmpDuugKSvZEtY=;
	b=V5Ac+VrAVyaQkHTp5syQHseqykN7pXK2ZSV0DyMFN7eH9YLiWVibVg/rvG3FKI5QgNd3msoOT7SZNbsKoSspkQUW1ZsqpqlOHEVa56+jBRJxvF6sSWif2d3Qdu+LPkQjZlk3pZa2iUZ38WN9PPil8h2kphxiJYv0gNBMGKyqVSU=
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WxfLOyU_1769160678 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 17:31:19 +0800
Message-ID: <b1747380-1f2e-4edd-81fe-f01b3fd01bad@linux.alibaba.com>
Date: Fri, 23 Jan 2026 17:31:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
To: Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-kernel@vger.kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, zokeefe@google.com, rientjes@google.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
 <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 60A1840014
X-Stat-Signature: 8jkh3hfexa11zjh8pwurgmmy9g6rqspo
X-Rspam-User: 
X-HE-Tag: 1769160685-29258
X-HE-Meta: U2FsdGVkX1+LQKgXNZW8ZNOVu/7xY6ev8M3gOyd3YPfRT8mPvCQvELfICc+yF28dpISJXUBBFV/OPb922xzm9f6IBNBsiOJBDP8MXat51EQ+r2wpNt7V/trzFRqSiELMvbgfxDwQ9Voi3RNUccB+N+krJP2BE20Y1c+d6K9WGWeRRDhu10TYLkjx60aGW8fEDmGPuJSKQtb6mCj4pc/v9/K1aqa/RhAbXvlOxb0nHobnn4hsGLlAqY7BJ64eKg95qW/4qXs0iuB4jZYMUHBbbCyfFdrOCETLckQdljK4llGg2Jfq6o1x3LDKnKgKAX3woQxIDf5VspwMgBieqEON4riXLClzqxMvq9D8IGPCi82PWGw9L5dhjmix7GBc4Znwn3fmDmk49UflNIO8z2Fc42iTOwHPuUBAKBykPIL7FXApuy474JCNk5Wb+PfhE1Vzt+FcAKdkoqMtPmvGtwNvR1tUNi/ZC0hOXXPqGgro3zwIrCsIQ/rTK9SwRILM6FA2e0UkHIpWKmn0H7uj+pE1Bwiv0wBsfctqNNayYKXtUZkl7D+iEL7OanYwwVPw39oEfblvzDcKqz3qZHa3LKW5C/l2+uEt4ULgk8NEa8BMGqXqxN7a2pApORO8DcATPS4H+tkzL9w8/Eu5giad0BFfPCE8vUH8lx6b8/1UiK88H/qp5IDpSCTQIRYIt4q5Ho5oc85pJ2F5OevSTm+VTtld2eP/SOalzZj/0HS9MkYc0CzuYJTr11jfb00vqmS/xH3P27tzgpeG5M5TvKjt/sIg4jTrineKKIEVEVuzfu7WFMKmWR1kqKQUZ8xemO+uMtQnKZERb0ujCHtfNKYtxs7/qW39guh3SiUpNLVj5e62YlaOei8a9ZAPEwOXA6soyIsxO2MF/55RGoO9D660iPyox54gcbrTj5PdTv1OPftfpLcTnuDE0S9zTIGWoGQkGG4+0E1gzsrJqzO/cjAyWdU
 8twRXPm6
 FSC5E3JVu362uRXg1L1AhGAgkEX6xJdAjXkm69MuMn2zs2iXdXpzV4vifVuAiEZ5fGQ1OPMz4MwgZUS4rpSBVyxxCTsPEtlqJCHhumUXgDRxDhnHM4p8OKU6AMBm/pOX8IVcT3H8fbKhq0M8AX73hlD9wVM4V7JSz0CaDhCF1bgikhKcn+5n3ykKxrf6qfNXlHz8V8aICQcuhLHcsUyn1ZcuQmKgFx591he6d2+cmCNW6mvhVBCyvjP7vBVTMw4VF1+DQ/n2kEUBJ3gWpLn+HaGKojWUdVt8kzbi7ImthJwEX4Qs6ib6AY8dPWoQzZh6B5g+U3WcNF65Ai794TCE+RGarCrU9iwmRtOEln3DxNRxRGML7lWVNGwM1s2b0mlian04zqDF/Em9ANqS+jlPjPHRIxjHTNNSvKI9VPbNGWtkMawaOLdbY25JoVaWr8B+DLTWd0uwZ3vdgZywoxCJQOb6kTD0u1pYZe3cYESdNVBxx2E3fzu43Lm9YspqPPqsosbb3/aiH/AnOwoIS02hhlMKa2EjK40ejtqGKBNM6TJpS567KR9i1pzgnxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/23/26 1:07 PM, Lance Yang wrote:
> 
> 
> On 2026/1/23 03:28, Nico Pache wrote:
>> The khugepaged daemon and madvise_collapse have two different
>> implementations that do almost the same thing.
>>
>> Create collapse_single_pmd to increase code reuse and create an entry
>> point to these two users.
>>
>> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
>> collapse_single_pmd function. This introduces a minor behavioral change
>> that is most likely an undiscovered bug. The current implementation of
>> khugepaged tests collapse_test_exit_or_disable before calling
>> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
>> case. By unifying these two callers madvise_collapse now also performs
>> this check. We also modify the return value to be SCAN_ANY_PROCESS which
>> properly indicates that this process is no longer valid to operate on.
>>
>> We also guard the khugepaged_pages_collapsed variable to ensure its only
>> incremented for khugepaged.
>>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
> 
> I think this patch introduces some functional changes compared to previous
> version[1] ...
> 
> Maybe we should drop the r-b tags and let folks take another look?
> 
> There might be an issue with the vma access in madvise_collapse(). See 
> below:
> 
> [1] https://lore.kernel.org/linux-mm/20251201174627.23295-3- 
> npache@redhat.com/
> 
>>   mm/khugepaged.c | 106 +++++++++++++++++++++++++++---------------------
>>   1 file changed, 60 insertions(+), 46 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index fefcbdca4510..59e5a5588d85 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2394,6 +2394,54 @@ static enum scan_result 
>> collapse_scan_file(struct mm_struct *mm, unsigned long a
>>       return result;
>>   }
>> +/*
>> + * Try to collapse a single PMD starting at a PMD aligned addr, and 
>> return
>> + * the results.
>> + */
>> +static enum scan_result collapse_single_pmd(unsigned long addr,
>> +        struct vm_area_struct *vma, bool *mmap_locked,
>> +        struct collapse_control *cc)
>> +{
>> +    struct mm_struct *mm = vma->vm_mm;
>> +    enum scan_result result;
>> +    struct file *file;
>> +    pgoff_t pgoff;
>> +
>> +    if (vma_is_anonymous(vma)) {
>> +        result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
>> +        goto end;
>> +    }
>> +
>> +    file = get_file(vma->vm_file);
>> +    pgoff = linear_page_index(vma, addr);
>> +
>> +    mmap_read_unlock(mm);
>> +    *mmap_locked = false;
>> +    result = collapse_scan_file(mm, addr, file, pgoff, cc);
>> +    fput(file);
>> +
>> +    if (result != SCAN_PTE_MAPPED_HUGEPAGE)
>> +        goto end;
>> +
>> +    mmap_read_lock(mm);
>> +    *mmap_locked = true;
>> +    if (collapse_test_exit_or_disable(mm)) {
>> +        mmap_read_unlock(mm);
>> +        *mmap_locked = false;
>> +        return SCAN_ANY_PROCESS;
>> +    }
>> +    result = try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
>> +    if (result == SCAN_PMD_MAPPED)
>> +        result = SCAN_SUCCEED;
>> +    mmap_read_unlock(mm);
>> +    *mmap_locked = false;
>> +
>> +end:
>> +    if (cc->is_khugepaged && result == SCAN_SUCCEED)
>> +        ++khugepaged_pages_collapsed;
>> +    return result;
>> +}
>> +
>>   static unsigned int collapse_scan_mm_slot(unsigned int pages, enum 
>> scan_result *result,
>>                           struct collapse_control *cc)
>>       __releases(&khugepaged_mm_lock)
>> @@ -2466,34 +2514,9 @@ static unsigned int 
>> collapse_scan_mm_slot(unsigned int pages, enum scan_result *
>>               VM_BUG_ON(khugepaged_scan.address < hstart ||
>>                     khugepaged_scan.address + HPAGE_PMD_SIZE >
>>                     hend);
>> -            if (!vma_is_anonymous(vma)) {
>> -                struct file *file = get_file(vma->vm_file);
>> -                pgoff_t pgoff = linear_page_index(vma,
>> -                        khugepaged_scan.address);
>> -
>> -                mmap_read_unlock(mm);
>> -                mmap_locked = false;
>> -                *result = collapse_scan_file(mm,
>> -                    khugepaged_scan.address, file, pgoff, cc);
>> -                fput(file);
>> -                if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>> -                    mmap_read_lock(mm);
>> -                    if (collapse_test_exit_or_disable(mm))
>> -                        goto breakouterloop;
>> -                    *result = try_collapse_pte_mapped_thp(mm,
>> -                        khugepaged_scan.address, false);
>> -                    if (*result == SCAN_PMD_MAPPED)
>> -                        *result = SCAN_SUCCEED;
>> -                    mmap_read_unlock(mm);
>> -                }
>> -            } else {
>> -                *result = collapse_scan_pmd(mm, vma,
>> -                    khugepaged_scan.address, &mmap_locked, cc);
>> -            }
>> -
>> -            if (*result == SCAN_SUCCEED)
>> -                ++khugepaged_pages_collapsed;
>> +            *result = collapse_single_pmd(khugepaged_scan.address,
>> +                              vma, &mmap_locked, cc);
>>               /* move to next address */
>>               khugepaged_scan.address += HPAGE_PMD_SIZE;
>>               progress += HPAGE_PMD_NR;
>> @@ -2799,6 +2822,7 @@ int madvise_collapse(struct vm_area_struct *vma, 
>> unsigned long start,
>>               cond_resched();
>>               mmap_read_lock(mm);
>>               mmap_locked = true;
>> +            *lock_dropped = true;
>>               result = hugepage_vma_revalidate(mm, addr, false, &vma,
>>                                cc);
>>               if (result  != SCAN_SUCCEED) {
>> @@ -2809,17 +2833,17 @@ int madvise_collapse(struct vm_area_struct 
>> *vma, unsigned long start,
>>               hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>>           }
>>           mmap_assert_locked(mm);
>> -        if (!vma_is_anonymous(vma)) {
>> -            struct file *file = get_file(vma->vm_file);
>> -            pgoff_t pgoff = linear_page_index(vma, addr);
>> -            mmap_read_unlock(mm);
>> -            mmap_locked = false;
>> +        result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>> +
>> +        if (!mmap_locked)
>>               *lock_dropped = true;
>> -            result = collapse_scan_file(mm, addr, file, pgoff, cc);
>> -            if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && ! 
>> triggered_wb &&
>> -                mapping_can_writeback(file->f_mapping)) {
>> +        if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
>> +            struct file *file = get_file(vma->vm_file);
>> +            pgoff_t pgoff = linear_page_index(vma, addr);
> 
> 
> After collapse_single_pmd() returns, mmap_lock might have been released. 
> Between
> that unlock and here, another thread could unmap/remap the VMA, making 
> the vma
> pointer stale when we access vma->vm_file?
> 
> Would it be safer to get the file reference before calling 
> collapse_single_pmd()?
> Or we need to revalidate the VMA after getting the lock back?
Good catch. I think we can move the filemap_write_and_wait_range() 
related logic into collapse_single_pmd(), after we get a file reference.

