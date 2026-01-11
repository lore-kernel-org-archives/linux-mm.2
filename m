Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBDBD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 11:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEBD6B0088; Sun, 11 Jan 2026 06:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2616B0089; Sun, 11 Jan 2026 06:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E776B008A; Sun, 11 Jan 2026 06:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68F5F6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 06:29:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E18D713B165
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 11:29:22 +0000 (UTC)
X-FDA: 84319462164.24.CD9D357
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42B3E120002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 11:29:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mBvTZBuv;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768130960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr9IEZ6NC3Nck2/RP9yu2pI+E4xWEV/Q+0h0Y2WOg2Y=;
	b=TKQSbKCVAPLgH+M3DjBMA2GNXURgcEKlVcVOxo5s2QacxVMT2sktKSjdMziTpQkG8+lqaE
	Hf58MUObgKryc78PcxqW2gWnoVwBy6jyEBS3p7kdWKNxsHPPjy9NrWkgERJTFdvg3pHPkA
	GPevCv5S0ybPMtst7xOTiKHrW3G2J5U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mBvTZBuv;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768130960; a=rsa-sha256;
	cv=none;
	b=VO8HWI8VEYNdinLGZOSe6r5xhJ4ZMEYGFKZQt3oWRbk5QOpZ6XVib4D2h5b4dRwrCeJDiF
	M8PL2NUb0zFIYE5uFnM4rmh09D+fHfMyuix7WjVMPjFXKZBBujM74ZWy2TQm5CpFrbpCOB
	IU2cytIhaSj732KT6GrDIjhYQBGBFbk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 666D060121;
	Sun, 11 Jan 2026 11:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAAEC4CEF7;
	Sun, 11 Jan 2026 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768130959;
	bh=womuZeNma+PUfURZTPPV2ETW16mKKdq53YWUvKmIWcU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mBvTZBuvQPbFIXaB48cWSXbQlcSo/KNgPTS1FSajgzdg9TC8BeM4GwW199ohYc9li
	 d9RnVaQ42UUTc7KBn8tejjXRyddxpgFliUacPE6ivr/UQ7UBJwODIPrzP4GwAMhvEf
	 YnNKaHZKCt7YR3bgXKwXa7fTXSOhu0i7pEK3dXLqlkgG5h7FzLJsDTKPeWMMeDCQOt
	 3MG+nvwaSYM/RDuFA62cJcEfbpzIkcOvVFOVyajeN/kaUjdt6KdmqddZbACW3vsHg8
	 J6J8hzCciVOBUk9T47muJfG6Zc4DpwUBxdbXfjuUy9YE1T4u01s93DvMrKxhbwbG0E
	 y2IcWcZZ8CvWA==
Message-ID: <d6287c39-59a7-4592-8afe-bdbdbcd70b04@kernel.org>
Date: Sun, 11 Jan 2026 12:29:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251215084615.5283-3-shivankg@amd.com>
 <20251215084615.5283-7-shivankg@amd.com>
 <3cc27720-8f53-4b6f-9202-42b3b73928b8@kernel.org>
 <dbbfc5f1-d9e5-4d39-a2df-e35d6ba73063@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <dbbfc5f1-d9e5-4d39-a2df-e35d6ba73063@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ssuxduin94sw6gm4mguneftf6mstzeho
X-Rspamd-Queue-Id: 42B3E120002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768130960-849421
X-HE-Meta: U2FsdGVkX1+cGnglZm3xaGnTX70maLNmjAnnq2dOz+b0gVQ31T/LsVaK8QdA8p5pgCqs+ORq+TqD6o/B19JMxOT4kAxdTIjuuFAM3T+t9ZIvQM8jp87xBGSYwDICkxRh3ID65fNNvoUnmmhACc2vuvy4QfYi3NXOPirYoaaGShtAbfl1AZXNaGq1uTWADOG38kOLsolL/h6WOi/GSWlrbxxf0pChtrn67/JuhaXSqJaW6WpcG2e4BtEVJQr50WSJCJt8GvTicVT2mg0gQRxJg/VejrGfqEGDSadPErHpFHbmEKKLF3MmMPfxB0+E3XJ+PzXmqIzhzpk0URO3ZCyHGeUyhnuYc3Pj9TPkzaM/KUHzjGqnT69ssUSWy0JZyXgYdsLs/IM8BBKCaEM43r7lluCQf3zGEtFyBtHhSrir5KoAbVd2L20HPJdPnoOrJ+zAgR3s/5nKVi3ihc7hWmfJFvpgqWUEUxSw79/DLlyZr/wR9Jv6Iek64RlgnHN44IEwOd6cMF0yH2cuUqNdMOiXzO20WSmsGJmXQzxM6clXViM8Yg8XP0YnrqxACX79ayvxQLh9wV3eN8d1dFyfs1TobFnH2M0mH22U99Jk5JnkNU+QLCBoenCxchckv3x7ZG1UDlmFP59c6z2XbFUU3KBpwPh+LVV7iNKwqFTfpyXobsnTOpCG12ta6tYYZfIczGouOLGM225/aKJ4NWlxY0Bvw7CIW2qnjth7asq9HFtMBXcwX0sBbmS7WNt0tmxkMKCSw1ZyWkAwSJWgo1ybgjYM2y2fhvlsXknAhGxPzZ65es8bMte73eYNEe1WJo4rDdceP56rLV+ByHuropJHv1ByiwvN+pQRP4FEL+sqS1A6KWFql1sg7ZbfSAdHLijNu+D0IX2KzQu9ABY6nuKs2FHXKKewnS9SXy8BKBVk+EeLWAhDicHItCgrPgsq4Ytq5EnEEfl/0Px11Q0YhxsGNmu
 EhtymHPw
 RektWS7/zgUnL0UN6qs1RWw1AbeoB1jusQY/31ZXfkAQEiCiByBPR8ZNng5cu0IbVwVSqxQl4MCfC6tClNxiQSl5Aqv/i9aLGZM8x4+8g0k8ubeP54NkW+J3UjDK3O1VXy2vUw4fHvrVhsghLq8HGuO/bJ7JNnqplOwaJEcW0ua3t31S5vxsBegPHcda+BbcCQQs+KFhDDpPF8NHBA1JYk73Ns0IgwfiVcmXftRfcWF9/tde4lakeDEhacdmr71tF3cjULDmSOefrOkHivaLo7DqQnlfbNyUl5yne/pBIM13nHpui43lKZiY7jTd6+gFCgzLCvbBi9tV2hzHopWTRBFYvICOKK57KXNxKJYR4utiMdG778qHsm9YDB6AIVeavZWlGHr+6rWnjKHHN8mDqwUCxsY8YY+OQ8DhO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/10/26 19:20, Garg, Shivank wrote:
> 
> 
> On 1/9/2026 8:16 PM, David Hildenbrand (Red Hat) wrote:
>> On 12/15/25 09:46, Shivank Garg wrote:
>>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>>> text sections), the pages may still be dirty from recent writes.
>>> collapse_file() will trigger async writeback and fail with
>>> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
>>>
>>> MADV_COLLAPSE is a synchronous operation where userspace expects
>>> immediate results. If the collapse fails due to dirty pages, perform
>>> synchronous writeback on the specific range and retry once.
>>>
>>> This avoids spurious failures for freshly written executables while
>>> avoiding unnecessary synchronous I/O for mappings that are already clean.
>>>
>>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Tested-by: Lance Yang <lance.yang@linux.dev>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>    mm/khugepaged.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 40 insertions(+)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 219dfa2e523c..6c8c35d3e0c9 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -22,6 +22,7 @@
>>>    #include <linux/dax.h>
>>>    #include <linux/ksm.h>
>>>    #include <linux/pgalloc.h>
>>> +#include <linux/backing-dev.h>
>>>      #include <asm/tlb.h>
>>>    #include "internal.h"
>>> @@ -2787,9 +2788,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>        hend = end & HPAGE_PMD_MASK;
>>>          for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>> +        bool retried = false;
>>>            int result = SCAN_FAIL;
>>>              if (!mmap_locked) {
>>> +retry:
>>
>> Jumping into an if block is nasty :)
>>
>>>                cond_resched();
>>>                mmap_read_lock(mm);
>>>                mmap_locked = true;
>>> @@ -2819,6 +2822,43 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>            if (!mmap_locked)
>>>                *lock_dropped = true;
>>>    +        /*
>>> +         * If the file-backed VMA has dirty pages, the scan triggers
>>> +         * async writeback and returns SCAN_PAGE_DIRTY_OR_WRITEBACK.
>>> +         * Since MADV_COLLAPSE is sync, we force sync writeback and
>>> +         * retry once.
>>> +         */
>>> +        if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !retried) {
>>> +            /*
>>> +             * File scan drops the lock. We must re-acquire it to
>>> +             * safely inspect the VMA and hold the file reference.
>>> +             */
>>> +            if (!mmap_locked) {
>>> +                cond_resched();
>>> +                mmap_read_lock(mm);
>>> +                mmap_locked = true;
>>> +                result = hugepage_vma_revalidate(mm, addr, false, &vma, cc);
>>> +                if (result != SCAN_SUCCEED)
>>> +                    goto handle_result;
>>> +            }
>>> +
>>> +            if (!vma_is_anonymous(vma) && vma->vm_file &&
>>> +                mapping_can_writeback(vma->vm_file->f_mapping)) {
>>> +                struct file *file = get_file(vma->vm_file);
>>> +                pgoff_t pgoff = linear_page_index(vma, addr);
>>> +                loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>> +                loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>> +
>>> +                mmap_read_unlock(mm);
>>> +                mmap_locked = false;
>>> +                *lock_dropped = true;
>>> +                filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>> +                fput(file);
>>> +                retried = true;
>>> +                goto retry;
>>> +            }
>>> +        }
>>> +
>>
>> This looks a bit complicated. Can't we move that handing up, where we have most of that
>> information already? Or am I missing something important?
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 97d1b2824386f..c7271877c5220 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>>   #include <linux/pgalloc.h>
>> +#include <linux/backing-dev.h>
>>   
>>   #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -2786,7 +2787,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   
>>          for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>                  int result = SCAN_FAIL;
>> +               bool triggered_wb = false;
>>   
>> +retry:
>>                  if (!mmap_locked) {
>>                          cond_resched();
>>                          mmap_read_lock(mm);
>> @@ -2809,6 +2812,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>                          mmap_locked = false;
> 			
> 			  *lock_dropped = true;
>>                          result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>                                                            cc);
>> +
>> +                       if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>> +                           mapping_can_writeback(file->f_mapping)) {
>> +                               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> +                               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +
>> +                               filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>> +                               triggered_wb = true;
> 
> 				  fput(file);
> 
>> +                               goto retry;
>> +                       }
>>                          fput(file);
>>                  } else {
>>                          result = hpage_collapse_scan_pmd(mm, vma, addr,
>>
>>
> 
> Thank you for the suggestion, this approach looks much simpler.
> 
> There are two small nits I observed:

Yeah, was a quick untested hack to see if this can be simplified :)

> 
> 1. In the retry loop, it is possible that we reacquire the mmap_lock and set
>     mmap_locked to true. This can cause issues later when we do:
> 
>         if (!mmap_locked)
>                 *lock_dropped = true;

That whole logic of having two variables that express whether locks have 
been taken/dropped is just absolutely confusing. Any way we can clean 
that up?

> 
>     because the caller would no longer see that the lock was dropped earlier.
> 
> 2. We need an fput() to balance the file reference taken at line 2795.

Ah, yes, makes sense. Having a single fput() would be nicer, but that 
would require yet another temporary variable.

-- 
Cheers

David

