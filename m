Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075FBC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1575B6B045C; Mon, 17 Aug 2026 05:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12EA56B090D; Mon, 17 Aug 2026 05:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D546B090F; Mon, 17 Aug 2026 05:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB7396B045C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:34:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60A721C15F9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:34:41 +0000 (UTC)
X-FDA: 85110251562.10.CD33E91
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE86D40004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:34:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vJGwPUh1;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786959279;
	b=sXU7ls91zPDoj+BLLinETt9bYssHIM5C4Ado+laIP7Dnp3C3rVjnSeRD4lAh58AbpdDKKu
	Mi05TsYck6BlX+EV3b+dpgwLcLbk+FHo6TjvZy/PGI9hVnpMYCxTyKb/a2HOnXr8hlZcHW
	FSRAg3kht2S1eL3XtqjcEYbWrOsmpNA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vJGwPUh1;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786959279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Dpf8rNnkAaaE60/W1M/0ZbnWHpXRdwLly7Psg5rJcI=;
	b=dUJr+oVWkKPScAE2UaJz9WYpuyXVqZJBf2u4V9kTUoozkjfDPTihsK9KZNv9Hh2yKwP4l5
	TLKWL/+/+zPbNKM+2x4lY8HKcx90V9TnJ5L4IL2FJ0+le0pjhnzewThfDJ/DDzSc9zMRMP
	0dGZFdoFgwiXiWYLBn076EKlbGAowD0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786959271; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4Dpf8rNnkAaaE60/W1M/0ZbnWHpXRdwLly7Psg5rJcI=;
	b=vJGwPUh1A2MKFgCapzLJL0FGpvfg28Yn+mvfTFJ1JUF2xPextN2nY1H1dhumz1UDYdgonSRYvepSGJg/GhSXUlFHIlBnkwyM63QhINB+5PKcgQK+FuEVrrsvquou9/rl6qQjS97475MmD8GB5x0q+SYU0ob57HEzatAuGCPHgGw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X95hlMe_1786959269;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X95hlMe_1786959269 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Aug 2026 17:34:30 +0800
Message-ID: <3246987a-7f99-4dcd-b3f9-50d9a8c112ff@linux.alibaba.com>
Date: Mon, 17 Aug 2026 17:34:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix incorrect vm_flags usage when checking
 allowable orders
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com,
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
 <aoK3JcBYe_JuydGm@lucifer>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aoK3JcBYe_JuydGm@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE86D40004
X-Stat-Signature: tgaez6gum3hyf9aw8xjft6fwog7h1syy
X-HE-Tag: 1786959275-504119
X-HE-Meta: U2FsdGVkX1+Xo6XCAupnefZv7sVTP6/iwUg+A6LIr80JA1Li/5peSLcmzeMvYg+dkcBOsEEGE0hC9FIeOcFp11a7RDTINZNyoB5lC7rym7Q0lxRdzzOIkdztHWRz7RwiMX2CjilSSsZvvqXNYmhx/t4J1BU6OqXSR/bxNVIH7dSExSWE9ZnfIQ1swQLg3RJkh0civjB+lkA2oVGuQqjt0b4BE+ACgr3TCO0ID5OI8Cpt4Vo9N15QYyJnbXPdwSNuvlH+/JTLArybpjsCBMBlQq4UkJELhevlU7xAOi0DNzSRKZ6olZLjtoglEjvI1wy93Up1uiGgMfe59L8R+XOlPSA2k7QyIOGjawnY1ovrKZjiN5OVpXlnFg6PetqWA9HnPyRR5UFoqeuz58kaBwXUx5ADZSkzd3GcKgelu4JR+99v71+7k33Ten5a2y1Pwte+y6nDjhiczmi7kZVPMge3dM/9wpdseK7HbtxSrF3pCmWFs0ly5V7bKosVsv3v/CigZnNl/VeSNotdqNg1+IR168A04wOZJCCKVCuxaDgszQOl5OiFvS42/Du33SKi/t7K2eWKwH21z/V4iU+nukTaJXSleal/maC3n864czfZopefyjI8J/9f9Erry39r5AT2sercpuKXPaqIxeWglfRRTmZTc679oyomsh16bkcfGSUzFciAb8bBwx5XbanCccmfjcvHWtUCfuoVvjYvWbmyCELOq04dSzV8XxoAkl5zVCtG7lhseW7yz3pRb07zeQmaPu1fW4OEfyVraf/QYtpO4+9HZ3akC5Y8ezf1sC6MeY2qxME+zUgrY0HDvIarms6MHjx1wi6Q5TSeZnWE/GLZmcKNCO6DV+olHg3YJILwQqETsieYLu0lVx1CzrncR9sgOVEMRmj/073X6iC1xm/5wODY2+4AVp6bD4jjUFTlHaFefjjjXSR6npvCZ71C2s/jTG9SlYq9NetoDdORj8Y
 sarophhk
 A5r+wyDLKCtYqiip11KZpVPOGaBLWoANvvu5wX+IHTCu+PqtF/6uR5QF2TYRnwRW5ANnLeIUQbbpiSSdviY+LY95IPLijs2Zxa3mlbZh67svvZINcVEaY75NWL6jy+82hbGEWkPNFGASyw4ayPs/1HNrcQy9NjWmyS4GagjJ8NLVxdaCnkM3NZY0tQrGiR6HnZmFdUJfCnLlbf7wjksdbOgtQNJ94tIa9LlVy1nF8Kc+jiuMgWEfG2bJ+7ZfYCOAhLI5SgqJmRFnron5hZl9mu40svl5hKSZ4h2uCNOhOk2r1WwWJALsyPqy9E7UVRNcO+xU0BfKjqUmd2Y6Ln8dUukEfoUNbJz092AcTDDepUkzQO9RaHKv3OWOhYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/17/26 3:40 PM, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 17, 2026 at 03:16:43PM +0800, Baolin Wang wrote:
>> Lance reported that when MADV_HUGEPAGE is set on a tmpfs file mounted with
>> huge=advise option, khugepaged fails the allowable order check and does not
>> scan the tmpfs file for collapse.
> 
> Ugh.
> 
> But really I think this isn't quite accurate - what you mean to say I think is
> that when _nothing else_ causes the mm to be considered for khugepaged collapse,
> an MADV_HUGEPAGE-advised tmpfs VMA alone does not cause scanning to commence.

Yes.

>> After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into
>> shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check reads
>> vma->vm_flags directly.  However, when MADV_HUGEPAGE is handled,
>> khugepaged_enter_vma() is called before the VMA's vm_flags have been updated,
>> so the check uses stale flags and incorrectly rejects the VMA for collapse.
>> As a result, khugepaged does not collapse the tmpfs file into PMD order in time.
> 
> Could we at least refer to the non-deprecated field in the commit message?
> i.e. vma->flags.
> 
> Probably worth mentioning VMA_HUGEPAGE_BIT also.

Sure.


>> Fix this by passing vm_flags as a parameter to shmem_allowable_huge_orders()
>> instead of reading it from the vm_area_struct.
> 
> Ugh this is so disgusting.
> 
> I understand this is a fix for a bug to be backported but couldn't we just
> achieve the same without having to add a deprecated field to be passed around?
> 
> As you say the khugepaged_enter_vma() isn't really so helpful in
> hugepage_madvise().
> 
> But you could add this to the bottom of madvise_update_vma():
> 
> 	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
> 		khugepaged_enter_vma(vma, new_flags);
> 
> I don't think this is really egregious on this code path and could go some way
> towards us eliminating the silly thing of passing around flags-to-be-set.

This is not the point (maybe I didn't describe it clearly). The point is 
that the allowable orders check for tmpfs in shmem_huge_global_enabled() 
(called by shmem_allowable_huge_orders()) uses a stale vma flag.

static unsigned int shmem_huge_global_enabled(struct inode *inode, 
pgoff_t index,
			loff_t write_end, bool shmem_huge_force,
			struct vm_area_struct *vma,
			vm_flags_t vm_flags)
{
	......
	switch (SHMEM_SB(inode->i_sb)->huge) {

	......
	case SHMEM_HUGE_ADVISE:
		if (vm_flags & VM_HUGEPAGE)
			return THP_ORDERS_ALL_FILE_DEFAULT;
		fallthrough;
	default:
		return 0;
	}
}

So we should pass the new vma flags for shmem_allowable_huge_orders() to 
check the allowable orders for tmpfs. Changing madvise_update_vma() 
doesn't help with the allowable orders check for tmpfs.

> And yeah you'd endure a little backport pain on switching that new_vma_flags
> vma_flags_t test to a new_flags vm_flags_t test but it's not so bad :)
> 
> I will be doing a series soon that improves the allowable orders vomit-a-thon
> somewhat in tip :)

Great. Look forward to seeing these cleanups.

>> Reported-by: Lance Yang <lance.yang@linux.dev>
>> Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
>> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/shmem_fs.h | 8 ++++----
>>   mm/huge_memory.c         | 2 +-
>>   mm/shmem.c               | 9 +++++----
>>   3 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>> index 5663dff53186..321017e0fd63 100644
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -127,13 +127,13 @@ int shmem_unuse(unsigned int type);
>>
>>   #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>>   unsigned long shmem_allowable_huge_orders(struct inode *inode,
>> -				struct vm_area_struct *vma, pgoff_t index,
>> -				loff_t write_end, bool shmem_huge_force);
>> +		struct vm_area_struct *vma, vm_flags_t vm_flags,
>> +		pgoff_t index, loff_t write_end, bool shmem_huge_force);
>>   bool shmem_hpage_pmd_enabled(void);
>>   #else
>>   static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
>> -				struct vm_area_struct *vma, pgoff_t index,
>> -				loff_t write_end, bool shmem_huge_force)
>> +		struct vm_area_struct *vma, vm_flags_t vm_flags, pgoff_t index,
>> +		loff_t write_end, bool shmem_huge_force)
>>   {
>>   	return 0;
>>   }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ced400f72d43..70f57d700739 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -187,7 +187,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   	 */
>>   	if (!in_pf && shmem_file(vma->vm_file))
>>   		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
>> -						   vma, vma_start_pgoff(vma), 0,
>> +						   vma, vm_flags, vma_start_pgoff(vma), 0,
>>   						   forced_collapse);
>>
>>   	if (!vma_is_anonymous(vma)) {
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 599665a3d6e7..6f1ad5456aca 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1834,12 +1834,11 @@ bool shmem_hpage_pmd_enabled(void)
>>   }
>>
>>   unsigned long shmem_allowable_huge_orders(struct inode *inode,
>> -				struct vm_area_struct *vma, pgoff_t index,
>> -				loff_t write_end, bool shmem_huge_force)
>> +		struct vm_area_struct *vma, vm_flags_t vm_flags,
>> +		pgoff_t index, loff_t write_end, bool shmem_huge_force)
>>   {
>>   	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>>   	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>> -	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>>   	unsigned int global_orders;
>>
>>   	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> @@ -2430,6 +2429,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>>   		gfp_t gfp, struct vm_fault *vmf, vm_fault_t *fault_type)
>>   {
>>   	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
>> +	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>>   	struct mm_struct *fault_mm;
>>   	struct folio *folio;
>>   	int error;
>> @@ -2507,7 +2507,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>>   	}
>>
>>   	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
>> -	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
>> +	orders = shmem_allowable_huge_orders(inode, vma, vm_flags, index,
>> +					     write_end, false);
>>   	if (orders > 0) {
>>   		gfp_t huge_gfp;
>>
>> --
>> 2.47.3
>>
> 
> --
> Cheers, Lorenzo


