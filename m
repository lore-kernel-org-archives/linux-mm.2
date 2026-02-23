Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BFAEA4FC3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725BA6B0005; Mon, 23 Feb 2026 09:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4786B0089; Mon, 23 Feb 2026 09:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6346B008A; Mon, 23 Feb 2026 09:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4AF6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:41:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E541AC08D5
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:41:35 +0000 (UTC)
X-FDA: 84475984950.22.56E2D0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B20740006
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:41:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vRne8mVm;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771857694; a=rsa-sha256;
	cv=none;
	b=P62u7xVTeiAFULsxoMlzu5d9XUFIsNeA/HUDpox5Or6ljBwnUwc8kHO814VgXxVuI7aYLu
	X1nw4+vjYyDtEaYSu+2swddENmsy+TrVQoFBa4emlR0RCNStx8JvZEei7iGp3wXhXz2uVd
	DLmXdr18aXW8vIxV+VHl1GBt3iuN7ZU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vRne8mVm;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771857694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8F9WbSsDtCpufhvlx/4oN5puhQXuRNF+WJQ4pjTRdM=;
	b=td0asuHUAICLQlLXLqzZAUCoGEXNtD6gRz0CCxHsIQscrJx/VykdmnnILGmEVntowQmuER
	FnXQ0mGyy9YXNeQ/SAkrmfY7gldxfNUri7N584tai8xhfKDldHcqievzNwGRnqnr+btjQL
	7jLSEODT5IbDpjc3t0EkAoPp7KToTpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C14284401F;
	Mon, 23 Feb 2026 14:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA9CC116C6;
	Mon, 23 Feb 2026 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771857692;
	bh=QD+SNLUSuTOZKVO6kq/rHyuVfqWXDuG6rqionI0X+CE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=vRne8mVm1wUiMLJe3Q5/Vuut0AOOqPzy4TiDA3vajKEww9dOqSPce0/sidKexz+5d
	 sMkziN7KI1NkCQHG91cG4a0KyhtK+WEGF/BduZ79fojPH85oPjME4/Z35nb6S7JQ7j
	 0/UnDhWRIHKBAkxHjHmnwzVljRQvHePlmFHGedRJY/TysUX8W5ar5ezNZN6aSHQW95
	 Tozog1PMIGvWkvtR1X85A9HOuBPeP1lY6jZh74Dl4aDKhrBIu00wuqy3jFNDoM7kOD
	 egkN/L+xlTtVBLhhDDtptkSReTb/F8uJqpJF79HnILbTJLeikuBXByaY5++GyWgCkM
	 OiDlr5yT5hCeQ==
Message-ID: <92e9d637-988a-4201-8c8b-c29987b727bb@kernel.org>
Date: Mon, 23 Feb 2026 15:41:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
 <62d53608-ed7b-42fe-baad-3023764383a3@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <62d53608-ed7b-42fe-baad-3023764383a3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B20740006
X-Stat-Signature: p3h8x1x9n5fbdxa5jr5cptz6856it44n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771857693-406595
X-HE-Meta: U2FsdGVkX1+b3Lusb4vWOvw4YYzFjCCdNZWGJEVtYcsVasCRnQ6YjozCRCCQV6lvAzF9D27Poz8LpK4f/D8F3mqIurEuqIoEpCu0+pmSs3cjSgqbxqKXvqmJMnIy05QygATQz6q2FH2TIYUn1xoRU0fIQBsLTnczCMjN3tvxP3w7vXfNQc6BUzv5Tb74OPUH6DiReQJDlvCt01Zv8BkgPDj5ONUmRaIO+IXWqxGnbRO5d7JdKhH9IGjHDU9AnN9ZCerg3tJifvN0GugZnBOZtcKMLZryBpOBKiixXpAvRGsZl9UoLrOsG+rpaJ4Fbu3OgqWL/K2jRIenNCLZ2C+NlYefpGYTEW876lTf1Sg03P/TPqR/u1hj5/nc/UaDx3ULpgOlMgpEzMt52MpPgqgSvu1UojSkYzkDwqZ4CV69m+rvvLxGRpLxa5rRmj3NtdzJRVKgivztQrAttWtWtjZDU+61cVYmW140A1J8Mm7NPAvcdU7dpIxFqkmC5tvYnDv+mH4eXyDSwHgDmTMCvmvXnj2qCx3qBwu0rreZby0039/SkL8CmgOToLVwevW3N0Nn2FD2Fro+rJMc5YceAJDW5OnSYePC/sTgDdstwfhkSo/eErpZAgNRkuJ3MqhRPPi916KzJx+nxR7mUPUGHhSWSEne9SFDbEs5ICQ4TEdEhCR+8EwtR8peX4FotNrj2hhtG3oxqDw7heqUH+FjPrV8m+DwV4wj+kfQ8BY6XCO3dw5TEcbS/0P+6lZQwyZIl+4RVDCgPiKJgVGnf5vZ0Ey0mvnswmEy4JT6A3h/DCTz8yE3e8fFx0gssKR+MiwWmklFeRQYzgmIo0aT/kbo2WoBh2AEpOwKOsVq3sy37LXQzfCmvTrqmy44unKPo3aeIlmRlkwkh0oGfg6jx5Mk5G6Lm++dZSjD6hklOk1oZxj5fsBtf2x0W7zxDnCB0C0ElBmHp3gyAhf10/H4mp/cP/3
 DXoImVDw
 UR2vzTxnYPuZkEioapnf5nb2v+/6YRKRXRLtYBBpqvkzkgB3yvGjFELhqTaXGgSgwWhs5quT1AtK3hwMIRdLXyIpG5j+MTTcCWdCCwtPRyDf5oT+a+B1bWtNlRfgIlcn1+Zq/uEA6+IAa+z6QAAcDzL3X2Fcn0b1wgwvBjpV80Ei5j+Hh56TaYkJ5ZEV+KZBg1LO2sqRQecYWeKxB0fy1vzTkrS35sn5N9j7Ghir5dEnqIRhdD+vy+Ymeqr+ELdn+FLi3GGInP2aWGcH4Dez6/zyvuWYlXchemhzuFmqnfdTvueTy50y9ulnak2VdVUmB7ehrwo4BszfBdBIb8UX3okzS58qCE9DAQ9TYfitFiRcZhoksSbSFMFDV4AAEPmwaN9ofzZpe4WO+RN7D5FaDLgc+/bwkim6c4vRyX6dCcaB2WLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 15:24, David Hildenbrand (Arm) wrote:
> On 2/12/26 21:26, Nico Pache wrote:
>> On Thu, Feb 12, 2026 at 1:04 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> Having triggered_wb set where writeback is not actually triggered is
>>> suboptimal.
>>
>> It took me a second to figure out what you were referring to, but I
>> see it now. if we return SCAN_PAGE_D_OR_WB but the can_writeback fails
>> it still retries.
>>
>> Would be an appropriate solution if can_writeback fails to modify the
>> return value.
>> ie)
>>
>> if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK) {
>>      if (mapping_can_writeback(file->f_mapping)) {
>>         const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>         const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>
>>         filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>      } else {
>>         result = SCAN_(SOMETHING?)
>>      }
>> }
>> fput(file);
>>
>> we dont have a enum that fits this description but we want one that
>> will continue.
> 
> I stared at the patch and possible ways to change it, but I wondered 
> whether this refactoring is really the right approach.
> 
> The whole mmap locking just makes this all very weird.
> 
> Let me think about it some more.
> 

As we don't really need to re-grab the MM lock, I think we can just do:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 844a8a27845e..d546ff173833 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2395,6 +2395,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
                 struct collapse_control *cc)
  {
         struct mm_struct *mm = vma->vm_mm;
+       bool triggered_wb = false;
         enum scan_result result;
         struct file *file;
         pgoff_t pgoff;
@@ -2409,14 +2410,22 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
  
         mmap_read_unlock(mm);
         *mmap_locked = false;
+
+retry:
         result = collapse_scan_file(mm, addr, file, pgoff, cc);
  
+       /*
+        * For MADV_COLLAPSE, try to writeback once to retry the collapse
+        * immediately.
+        */
         if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
-           mapping_can_writeback(file->f_mapping)) {
+           !triggered_wb && mapping_can_writeback(file->f_mapping)) {
                 const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
                 const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
  
                 filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+               triggered_wb = true;
+               goto retry;
         }
         fput(file);
  
@@ -2814,9 +2823,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
  
         for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
                 enum scan_result result = SCAN_FAIL;
-               bool triggered_wb = false;
  
-retry:
                 if (!mmap_locked) {
                         cond_resched();
                         mmap_read_lock(mm);
@@ -2838,11 +2845,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
                 if (!mmap_locked)
                         *lock_dropped = true;
  
-               if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb) {
-                       triggered_wb = true;
-                       goto retry;
-               }
-
                 switch (result) {
                 case SCAN_SUCCEED:
                 case SCAN_PMD_MAPPED:


-- 
Cheers,

David

