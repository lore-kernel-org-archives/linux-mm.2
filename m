Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A53CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 03:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C44C8E0009; Wed, 22 Oct 2025 23:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7743E8E0006; Wed, 22 Oct 2025 23:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689D38E0009; Wed, 22 Oct 2025 23:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5468E0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:04:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9B681A09DB
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:04:17 +0000 (UTC)
X-FDA: 84027885354.24.5800016
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id E3CFA40002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:04:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761188656; a=rsa-sha256;
	cv=none;
	b=poEo+ljzuLy6qQietpqJ9hcmusmyXKjN5Dw38v9vJtPyUITCsFnNSjjS6V+fgS4qiEnnsx
	AI7sU8lR6htKyHEr6rX3WbWWuyM0A/l2E3bgUQEw1/T3G6pGFq0IROHCbI8XUG19y+3keH
	WfUu83ZvzNMcOYV1p09QezAkmn2dCyI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761188656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFly9w5L+9DVRSQJkwvVEmff3ZJFura2frsxl5no6P8=;
	b=neAr78laVSeNRCSARxDcvmKUG8xeFWecHBgZV1/G+L8C+y44CIn2dWXQH2z4Qe2IuFkqcN
	9NC40wuirmD6bPDXlOuUNN9hhuP9C64lOcoVJS4e2IgKPAObbNRf+ZnXjSu5d2KSyyFEs7
	VzfRiRdntTLnShgobo7OawiYJ43YFDA=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4csW7W5nZmzKHMLm
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:03:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8CA081A0F5F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:04:08 +0800 (CST)
Received: from [10.174.178.152] (unknown [10.174.178.152])
	by APP2 (Coremail) with SMTP id Syh0CgBnvUUmm_lolsEzBQ--.42363S3;
	Thu, 23 Oct 2025 11:04:08 +0800 (CST)
Message-ID: <610d89e2-6970-4924-824b-f27a2424979b@huaweicloud.com>
Date: Thu, 23 Oct 2025 11:04:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible regression in pin_user_pages_fast() behavior after
 commit 7ac67301e82f ("ext4: enable large folio for regular file")
To: David Hildenbrand <david@redhat.com>,
 Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org
References: <ebe38d8f-0b09-47b8-9503-2d8e0585672a@huaweicloud.com>
 <20251020084736.591739-1-karol.wachowski@linux.intel.com>
 <0fec500c-52ea-473d-b276-826c0f4dd76f@huaweicloud.com>
 <43cc7217-93bc-4ee6-99d2-83d9b26eb31a@redhat.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <43cc7217-93bc-4ee6-99d2-83d9b26eb31a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnvUUmm_lolsEzBQ--.42363S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtr1fJF15CFWDJF1UZw13Jwb_yoWxGF47pr
	ykKa4YkFW5Jrn5Kr17Ww4qgFy0yw4UJayDWFyrJFyUArn8Ar12vr4UX390gry7Xr4fAr40
	qr4UXry3ZF1UCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3CFA40002
X-Stat-Signature: c3s88keor4ptwkb9kpbfp85qpuisugxd
X-HE-Tag: 1761188652-437313
X-HE-Meta: U2FsdGVkX1/h5aP4DoPmsfmGR3TlkGl4VXKklaWEYkRQe+aRZdiArDuSyn+JGN120lpkhhFT5im6qZJLqQAjxgeNldhs0VABH4mZpMhN+1m4Nld61hD5gGw5fy0vv0c/i0TWBROwlVRoULnv2pcj6RVE6Yb1PuTp/Cew85EXAXrR8U574LDIMrmMmG46p/JGO5SnNNmsGx+adrW4wNnM5tXPl0WhifxGUIA7iKNJ2siXVbwn+wrblI40na9Ex3mni9Zy0cDmrnTQtFAPAgOvr85NTNgubPOHTx7BmbNem1O06Ld+DlHEyS0PQkH+7S1j1u/9U4Ev5cc7Dni447th42ULN9h9+hoJZdInmzTuKZLCpssNuggWlqAL/Y5s8uC/zk4YYmcC75rEEjYFQlzxww5nyGpGCcGvZQEm1JDqvFWtGVdVf/2alcbZ7nTXbIFHaHSsNy9khz1W5cxW1qaiak6UvWfPafjzXP9P/xaXLb1MylQKLup9WgGPAaxFo27e7J/KqWwWb2cjEzzSn7/KYhSlNux0Cd5ZnPSWoYS9HiQ/kEeiy+muhs8pLA74n9TWn+4hDt2qYnkJmIzmSiBTCHXrYlT8l0H41wcpYD1oTZ7cm6jOGD1kQOUQpl/iBLut3h2wcufrZmXItvS0y2o+mJF6UvkZtOb3+AivvJQUqMmNFp1W0wVu3DiyTMBZ5/mi2MRVFz4RTWV851dEW3HhfpBbHAQDQR3wKXua/AlhR/exUYTsAPw/MnuVAll/Q6FHS04LXSKgA/MBM0uwNNx23OS5iz89eigmiq/I1nHXicZfP0uu47lt6xJYlZJPC4UK3vNpaS+oz3xVrYBjKcOoJAAGzSeaxgSulLoUIbsOatyzM+yRR5envKisqF0vEbR1dZAtR+d5YhT8mo2Fe/UfoN6AUni8LHlgYVWunkjMNTB0Do+fg81Sdnr+HEJRmCpGYO3TBnHMo6paJR3qvVP
 QQ0zv4jA
 MZJMDvSYlLVGjjLP5BjkSRH37bb9RbJ+gEV6qpo2ChWlAFhc2+WgyWulOvnP/dh5W7EX89MA5/dpAUcBRd+B8OFr8NQH7SGG0F2gdxNUwEjUIsNQHZnUDEzBJWJOGZ/LV42QiEsm156SbgVBK653UoQI7BKCynj5JXdeC1GU0DjfO1AA1yfMjULF+6pBA0qHSk9GO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/22/2025 4:30 PM, David Hildenbrand wrote:
> On 22.10.25 04:46, Zhang Yi wrote:
>> [add mm list to CC]
>>
>> On 10/20/2025 4:47 PM, Karol Wachowski wrote:
>>> Hi,
>>>
>>> I can reproduce this on Intel's x86 (Meteor Lake and Lunar Lake Intel CPUs
>>> but I believe it's not platform dependent). It reproduces on stable.
>>> I have bisected this to the mentioned commit: 7ac67301e82f02b77a5c8e7377a1f414ef108b84
>>> and it reproduces every time if that commit is present. I have attached a patch at the
>>> end of this message that provides a very simple driver that creates character device
>>> which calls pin_user_pages_fast() on user provided user pointer and simple test application
>>> that creates 2 MB file on a filesystem (you have to ensure it's location is on ext4) and
>>> does IOCTL with pointer obtained through mmap of that file with specific flags to reproduce
>>> the issue.
>>>
>>> When it reproduces user application hangs indefinitely and has to be interrupted.
>>>
>>> I have also noticed that if we don't write to the file prior to mmap or the write size is less than
>>> 2 MB issue does not reproduce.
>>>
>>> Patch with reproductor is attached at the end of this message, please let me know if that helps or
>>> if there's anything else I can provide to help to determine if it's a real issue.
>>>
>>> -
>>> Karol
>>>
>> Thank you for the reproducer. I can reproduce this issue on my x86 virtual
>> machine. After debugging and analyzing, I found that this is not a
>> filesystem issue, we can reproduce it on any filesystem that supports
>> large folios, such as XFS. However, anyway, IIUC, I think it's a real
>> issue.
>>
>> The root cause of this issue is that calling pin_user_pages_fast() triggers
>> an infinite loop in __get_user_pages() when a PMD-sized(2MB on x86) and COW
>> mmaped large folio is passed to pin. To trigger this issue on x86, the
>> following conditions must be met. The specific triggering process is as
>> follows:
>>
>> 1. Call mmap with a 2MB size in MAP_PRIVATE mode for a file that has a 2MB
>>     folio installed in the page cache.
>>
>>     addr = mmap(NULL, 2 * 1024 * 1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
>> 2. The kernel driver pass this mapped address to pin_user_pages_fast() in
>>     FOLL_LONGTERM mode.
>>
>>     pin_user_pages_fast(addr, nr_pages, FOLL_LONGTERM, pages);
>>
>>    ->  pin_user_pages_fast()
>>    |   gup_fast_fallback()
>>    |    __gup_longterm_locked()
>>    |     __get_user_pages_locked()
>>    |      __get_user_pages()
>>    |       follow_page_mask()
>>    |        follow_p4d_mask()
>>    |         follow_pud_mask()
>>    |          follow_pmd_mask() //pmd_leaf(pmdval) is true since it's pmd
>>    |                            //installed, This is normal in the first
>>    |                            //round, but it shouldn't happen in the
>>    |                            //second round.
>>    |           follow_huge_pmd() //gup_must_unshare() is always true
> 
> 
> FOLL_LONGTERM in a private mapping needs an anon folio, so this checks out.
> 
>>    |            return -EMLINK
>>    |   faultin_page()
>>    |    handle_mm_fault()
>>    |     wp_huge_pmd() //split pmd and fault back to PTE
> 
> Oh, that's nasty. Indeed, we don't remap the PMD to be mapped by PTEs but instead zap it.
> 
> __split_huge_pmd_locked() contains that handling.
> 
> We have to do that because we did not preallocate a page table we can just throw in.
> 
> We could do that on this path instead: remap the PMD to be mapped by a PTE table. We'd have to preallocate a page table.
> 
> That would avoid the do_pte_missing() below for such faults.
> 
> that could be done later on top of this fix.

Yeah, thank you for the explanation! I have another question, just curious.
Why do we have to fall back to installing the PTE table instead of creating
a new anonymous large folio (2M) and setting a new leaf huge PMD?

> 
>>    |     handle_pte_fault()  //
>>    |      do_pte_missing()
>>    |       do_fault()
>>    |        do_read_fault() //FAULT_FLAG_WRITE is not set
>>    |         finish_fault()
>>    |          do_set_pmd() //install leaf pmd again, I think this is wrong!!!
>>    |      do_wp_page() //copy private anno pages
>>    <-    goto retry
>>
>> Due to an incorrectly large PMD set in do_read_fault(), follow_pmd_mask()
>> always returns -EMLINK, causing an infinite loop. Under normal
>> circumstances, I suppose it should fall back to do_wp_page(), which installs
>> the anonymous page into the PTE. This is also why mappings smaller than 2MB
>> do not trigger this issue. In addition, if you add FOLL_WRITE when calling
>> pin_user_pages_fast(), it also will not trigger this issue becasue do_fault()
>> will call do_cow_fault() to create anonymous pages.
>>
>> The above is my analysis, and I tried the following fix, which can solve
>> the issue (I haven't done a full test yet). But I am not expert in the MM
>> field, I might have missed something, and this needs to be reviewed by MM
>> experts.
>>
>> Best regards,
>> Yi.
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 74b45e258323..64846a030a5b 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5342,6 +5342,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>>       if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>>           return ret;
>>
>> +    if (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE) &&
>> +        !pmd_write(*vmf->pmd))
>> +        return ret;
> 
> Likely we would want to make this depend on is_cow_mapping().
> 
> /*
>  * We're about to trigger CoW, so never map it through a PMD.
>  */
> if (is_cow_mapping(vma->vm_flags &&
>     vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
>     return ret;
> 

Sure, adding a cow check would be better. I will send out an official patch.

Thanks,
Yi.


