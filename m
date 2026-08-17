Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9D0C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794506B00CB; Mon, 17 Aug 2026 06:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C266B00D4; Mon, 17 Aug 2026 06:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A88D6B0128; Mon, 17 Aug 2026 06:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4576B6B00CB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:54:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7B4A14073F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:54:14 +0000 (UTC)
X-FDA: 85110452028.25.398115E
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D97AC0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:54:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=knGrj9FC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786964053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3hXHOxNZFvP3ECw7qKsRya7tzKP/+v6sM6ift4LbNo=;
	b=Q7qhR7hM5kzJVD7nGqCv28Cgg3ib/PmE5OJu1Es6cogiHYfHWLph/Zw6LSZkY5K+znzyfg
	8F1tiKb2gN8OlqNGqtyQPG4cY6b8LU54+kP9h6Mmw4HeT2ubNziMSbWUbvFL4kj3Nsub9I
	YkaId/x/0NDm1OkRKVPqg9aCAC0jmIE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=knGrj9FC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786964053;
	b=aWG90yle/xXeP70Gb8l9o5LJi2t09IR4b1rTbAhlkuYsYJGgmwNe0S3oX1jlEkwB7HBtcX
	FWOGFvJRn6pv6aWQz28oOEkKCioPQAH8F/y0mN+zyDGWNHTn867+7gkmH5xvr7cLidAB4N
	t7YuH1Id+WqA0nd3bAI2Z7YBwncyCY0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786964047; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=k3hXHOxNZFvP3ECw7qKsRya7tzKP/+v6sM6ift4LbNo=;
	b=knGrj9FCWEDCrK0XjmlhVhA8DfGn+4Wl1Ww9ZuUULppDPVuAIx2m0FMr8aSQMRG+hXv1p1euOEBteARHK9au8NIgBWYqY/F1S36mNPyncjlYxTlIVCv8qHALlhUZUu5wzxsuqreMCqmLFDWOW6tYgaNPxtMOLbMPsyvq7zzx+AQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X96YJJC_1786964046;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X96YJJC_1786964046 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Aug 2026 18:54:06 +0800
Message-ID: <e4bed970-ba26-41d9-8cdb-a2f3922fbe94@linux.alibaba.com>
Date: Mon, 17 Aug 2026 18:54:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix incorrect vm_flags usage when checking
 allowable orders
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com,
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
 <aoK3JcBYe_JuydGm@lucifer>
 <3246987a-7f99-4dcd-b3f9-50d9a8c112ff@linux.alibaba.com>
In-Reply-To: <3246987a-7f99-4dcd-b3f9-50d9a8c112ff@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7hagrfifazrmj419a17h7z56xtszuz74
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D97AC0002
X-HE-Tag: 1786964049-752330
X-HE-Meta: U2FsdGVkX1+1W0FgvUnm2sn5piwtwLm6Nt0PA+wjjCN0+2D4Wwdr+5UMfIhw9I6J4AEfvrZmXbNo23gV1uu0uidHFS5d/VEqZR2Y76thlwR3VF+rAAg4PJHcX7vvTwBokmw6dEiXKnZbyNRcbz6B/2mfAL4SinV4ppNrzGeu8QW7eVQhgtwIlEl/iECxTu8w4m4e+pX5D8JbI3wWPUBc4AG0VBt4i6y+Ur1epBarnIPkDptn6LsZcZe3rlqj2xC9bEBpDyTx84hfTryO8EZJwLqUUlkNqMnlfXQEHpSstSmyirQ72uuwXN4okHEJU+6UjF//chnfamJMbQtDCBrLyBlZfk/VT42D3Cp6JlR4scoeIi85V/Q/orJYLflAoUg9Oygy/T5wE8L3kimcx31nPjsKc2NJ77RG2QM1jaa0xbZW1LT7qJeqjq3ltewpKMVtRtiyhoYZ0UtfY2Lwx6WH4Dv9lmR6TBWMUHLemviGCUP5EXIvLYZMHxL7wwagUn4e85HqDfF754InYLbRPSwn4bLnWAjAma5w3gIZhQY7qMK93TCu0LTysdfhBC0qblO9wN9SycyrUeu83/RBViWPzhnZpNbVkKVyYZAWJcHJu/kJBUFGMQlDVqAZTaLcZku9gssPRbPjaVwmMd/EFSf68nzCQMqNZgpty/DJcz4v7BkcGOJQc0TkueskqFg5PtzB9Qkm5cNZAuSbIfzT9ELpW3twwDdv8JzZFWKRhSTxIx6Ulp7+sauj+YtVNoU+GdaEZhS++w5t3x+uExOJCaWf2F74l+PJaIM+oaqz+BMfsAR5FfxwCCb6TKGHyxysgs5r4i1LaVHFKqX7oqEOrBm0BwJscWB5GRZVyMT1VnjkiewOZBCKalaAKPcYdiI2tjuTLpswoZCRIkD6eTvSPHHhC0aCxNcBGGoDevcBZ5T90NTQsMvUmfMGnYp1Hh4O77ZWUlECSTtEylUMhdyP7E+
 FzSOmfVN
 5vy0or6MX1yAOyGeteBrkV6Q3HnFNXzjJ7lPAjvzbwTgWZdAAPqvWuHa/cO5bUCUgkThd3WQWSNWVBkjtXG+qyfDi1BFMY6p5uD9Eqn5cLRdtzayVv82pcmUpdaP/oR0cw8DKZQ1DktEg7IEB5Fx42er56C8d8IwXQS6LRLU4csyEiU8105QTSr8/uMy1kl0tKkhFWS+rkXZJ089xHzLXzJ5liceTHSMs3wE6vVfQfSfJYxWFjxS0at+xrsBFjk82WztvPhmN4923rDW0ekOpTGNyVmQIAH9kQXI2jk7KQX2/RSnmpgxiC2fzPbvR3DHvkL32EBmCMvtRzkch0weAJ7CaSiC0g2hAL7YnbrsBnk2ycgANWP4XnTJiQ/ihv2F9yInT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/17/26 5:34 PM, Baolin Wang wrote:
> 
> 
> On 8/17/26 3:40 PM, Lorenzo Stoakes (ARM) wrote:
>> On Mon, Aug 17, 2026 at 03:16:43PM +0800, Baolin Wang wrote:
>>> Lance reported that when MADV_HUGEPAGE is set on a tmpfs file mounted 
>>> with
>>> huge=advise option, khugepaged fails the allowable order check and 
>>> does not
>>> scan the tmpfs file for collapse.
>>
>> Ugh.
>>
>> But really I think this isn't quite accurate - what you mean to say I 
>> think is
>> that when _nothing else_ causes the mm to be considered for khugepaged 
>> collapse,
>> an MADV_HUGEPAGE-advised tmpfs VMA alone does not cause scanning to 
>> commence.
> 
> Yes.
> 
>>> After commit 6beeab870e70 ("mm: shmem: move 
>>> shmem_huge_global_enabled() into
>>> shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order 
>>> check reads
>>> vma->vm_flags directly.  However, when MADV_HUGEPAGE is handled,
>>> khugepaged_enter_vma() is called before the VMA's vm_flags have been 
>>> updated,
>>> so the check uses stale flags and incorrectly rejects the VMA for 
>>> collapse.
>>> As a result, khugepaged does not collapse the tmpfs file into PMD 
>>> order in time.
>>
>> Could we at least refer to the non-deprecated field in the commit 
>> message?
>> i.e. vma->flags.
>>
>> Probably worth mentioning VMA_HUGEPAGE_BIT also.
> 
> Sure.
> 
> 
>>> Fix this by passing vm_flags as a parameter to 
>>> shmem_allowable_huge_orders()
>>> instead of reading it from the vm_area_struct.
>>
>> Ugh this is so disgusting.
>>
>> I understand this is a fix for a bug to be backported but couldn't we 
>> just
>> achieve the same without having to add a deprecated field to be passed 
>> around?
>>
>> As you say the khugepaged_enter_vma() isn't really so helpful in
>> hugepage_madvise().
>>
>> But you could add this to the bottom of madvise_update_vma():
>>
>>     if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
>>         khugepaged_enter_vma(vma, new_flags);
>>
>> I don't think this is really egregious on this code path and could go 
>> some way
>> towards us eliminating the silly thing of passing around flags-to-be-set.
> 
> This is not the point (maybe I didn't describe it clearly). The point is 
> that the allowable orders check for tmpfs in shmem_huge_global_enabled() 
> (called by shmem_allowable_huge_orders()) uses a stale vma flag.
> 
> static unsigned int shmem_huge_global_enabled(struct inode *inode, 
> pgoff_t index,
>              loff_t write_end, bool shmem_huge_force,
>              struct vm_area_struct *vma,
>              vm_flags_t vm_flags)
> {
>      ......
>      switch (SHMEM_SB(inode->i_sb)->huge) {
> 
>      ......
>      case SHMEM_HUGE_ADVISE:
>          if (vm_flags & VM_HUGEPAGE)
>              return THP_ORDERS_ALL_FILE_DEFAULT;
>          fallthrough;
>      default:
>          return 0;
>      }
> }
> 
> So we should pass the new vma flags for shmem_allowable_huge_orders() to 
> check the allowable orders for tmpfs. Changing madvise_update_vma() 
> doesn't help with the allowable orders check for tmpfs.

Sorry for misreading your code (I need a coffee before reading the email 
:)). Please ignore my reply. After looking at the code again, yes, this 
can work. If nobody rejects, I will follow your suggestion in v2. Thanks.

