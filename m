Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC9ACD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1986B0088; Wed, 17 Jun 2026 21:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A29A6B008A; Wed, 17 Jun 2026 21:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA3C6B008C; Wed, 17 Jun 2026 21:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4759E6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:11:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94FC51A0630
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:11:20 +0000 (UTC)
X-FDA: 84891255120.15.F42993A
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4EF041C000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:11:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KHSJkomg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781745078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJAVdhxMoAxAA0JtjqqP30vuvN13Fo3E4CXfWavT4Ss=;
	b=EVpHh92KAUOMTMM9NSaUdXN5lFv6nMHErVZUO9ghV9PqUz+J8owG3JrOt0NfWNGUTsiaDa
	1Yz8A8//BR1IC4QbVoNA3dOiib5v+Hl1c/hBc8Eb+8CKvUJIWy6yL4mJugGPF/PMk5OT5i
	UDV3qgvTgrjtg0EyNNbO/7xR1IcqAnE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KHSJkomg;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781745078;
	b=CIieNN1d929IeJvbKUGDVgjGwAbezd6S81Cf/xJshzgpFaCQzGP+vJFynLIv3hdPkYeOdF
	fzolRTouk7Jieu6Rc7k5rn0+gl8ccnxcsaYmhBQ4tr65iB4CoQ1OALXdu1MUsFG0FJzYOd
	G4Srjvyban3NVna5Kj/gHtstNrhw/p8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aJAVdhxMoAxAA0JtjqqP30vuvN13Fo3E4CXfWavT4Ss=;
	b=KHSJkomgUjDnBTSNAWwUG+UqJv5TJK8F1Uq14VvAC+FF6PuYDezbuiyd6kZlF79V17onDGMnC
	vUPVrdBhdaMZVOgQNGnucPg1YJeNFacPQ742StQePJ9BED93TE88bZxyvq+IL9vNEOJ8ZdDj8aD
	NlE6gWrz95uno+liOr3v7C4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4ggjBb1VhbzcbPH;
	Thu, 18 Jun 2026 09:02:47 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A3CF40537;
	Thu, 18 Jun 2026 09:11:13 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 09:11:12 +0800
Message-ID: <065b1900-1a4e-4d92-b588-002b844f1896@huawei.com>
Date: Thu, 18 Jun 2026 09:11:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use
 walk_page_range_vma()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
 <DJBESGC086ZC.3JSQ5GD3ALCY6@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <DJBESGC086ZC.3JSQ5GD3ALCY6@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: d6fzeddqime1sx188q4jcc74izwccph6
X-Rspamd-Queue-Id: 4EF041C000D
X-HE-Tag: 1781745077-125308
X-HE-Meta: U2FsdGVkX1+QN8/kIIGs7aXBzZldI9nD96b3WuPTzY6PE4uU3fgaqbYIMjQUuS1bxzSh5uol4uOoNH2A/a2TBnJdRMsQ34SgcMJQqGRBfZ8xIQXjrE9hKwO9tUewxEZ1lMJsBVzysxYy3W/vLKQ3ETIblr92S22MetUTWroEBVbWCGXlTxMdkQAOEF8GRWTN0/C5GB1rpcO/d6sq1fKlx/cMEWghCAerMQ0iV6JJzySCPhnCvMgOLVjEuHUqrfXNYzZg0rL9ZAgoNizCJ9w2/EsGKGGE5rgnO8GwOqJVMwItTvFvNyiqMSu8uxZh09RCKlnLWrYAT1XGc9i8FzXRurfLymmrghrVO7fM+0TUdn1RkhGKY4JtKvAudSprdYSZqng9L3NG5b+BAb+AzwJAJulMtcWmP3WpVX1sGgH0OgQ/0znpZgqGIkfrnMVCf4+wlX3jjU869bTQ+f01zTWOtslsXRGycI5OizUCOy7VDPVrYEBbLwLOe4S+quplYQBnyElSzPYo0/m8zhuE4zQ8+TgXiGQDdRDW1lLGKIIK/6954yz3mP7bBXLqlNPknZtCnswbQ8XDepXZZC1dOD7M+XQjXOGn7ZrncGXXCJkt7AZ1K9DH8IQLRjyj/NBHhjUKZUXId7OZYCJEZEYRNj+Q3DPTjWZhTzsbUkHuNtjdwsh6Ys6JRa/lTFaMMwlT68KllxJ+0SsbfqneO1igKHLhMo59r0qbeJ/D1efGaCiC0fYS3HmNWnRDENgkg/WPSb7Fc6IVfUiBRgAeeQxUKWaMu2kW9r1YqdDNxES0OZdXkdDx9vnTZpubOuSXuFBHyDTOcUEgxvprjiwV7AzeQGXUXvR90eM3ZSwn21qwMHQR7HVfkERPDga474vOhAwxRY5v/kdeOO6eJgQ2TSudYGFoNOXK7eEjOCP9wl+Rm0wgBkUHYP14mtUgOcCZUcO8P1TP2J94b7oYrJmAxOg5NdC
 fVFO8xzd
 571hKeewJQ/rbfcA/FbNcECHeDDhs4D7Dlp4MoUlkgnm1ogtYjGkV35C8nH9oZ+RQXsC3zy3yBgfbbh0caY8+kfBQFP/aixmkxN1LHk5/LrmS4DqvYPAwJeAQd7pEhEsAgu7HsT95wOevR6JimxyFQRxrHQEQouaZF6tFgS35IVGPoezejpnAaewR8kjV94SdhtDsn2y3DbTg0QEIxWsM4cKWg/xQvMwZYYIQzvq18TeAFSknr5fSdXquZGPFaAluvEd14w2kYVQ6/6Nm+eoMOJ1mGBcM9bPMBHN0eOAsMxhGyvXdZnK2zmIPVbCFDflgcSOX8cTfO3oUlA08emD9KBqYeFGqzKAQKqljZIhSpy3ftlIeTMdleotI5yb7Hv16BSgG9go0xH33fO8LTLcg5RVd5ROnf3v0aaK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/17/2026 10:54 PM, Zi Yan wrote:
> On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
>> The mincore syscall currently takes mmap lock for the entire
>> duration of the VMA lookup and page table walk. This creates
>> a global contention point with page faults and other mmap_lock
>> holders in multi-threaded applications.
>>
>> The mincore is a read-only operation that only queries page
>> residency from a single VMA, making it an ideal candidate for
>> per-VMA locking, so try per-vma lock firstly and use the
>> walk_page_range_vma() in do_mincore() to eliminates an unnecessary
>> find_vma() lookup.
>>
>> Unlike walk_page_range(), walk_page_range_vma() does not call
>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
>> to skip the page table walk. Without this check, PFNMAP PTEs
>> would be treated as present by mincore_pte_range(), changing
>> the returned residency status. Handle VM_PFNMAP explicitly in
>> do_mincore() to preserve the original behavior.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/mincore.c | 71 +++++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 53 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index 296f2e3922b5..a786a073feab 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -12,6 +12,7 @@
>>   #include <linux/gfp.h>
>>   #include <linux/pagewalk.h>
>>   #include <linux/mman.h>
>> +#include <linux/mmap_lock.h>
>>   #include <linux/syscalls.h>
>>   #include <linux/swap.h>
>>   #include <linux/leafops.h>
>> @@ -232,34 +233,47 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
>>   	       file_permission(vma->vm_file, MAY_WRITE) == 0;
>>   }
>>   
>> -static const struct mm_walk_ops mincore_walk_ops = {
>> -	.pmd_entry		= mincore_pte_range,
>> -	.pte_hole		= mincore_unmapped_range,
>> -	.hugetlb_entry		= mincore_hugetlb,
>> -	.walk_lock		= PGWALK_RDLOCK,
>> -};
>> -
>>   /*
>>    * Do a chunk of "sys_mincore()". We've already checked
>> - * all the arguments, we hold the mmap semaphore: we should
>> - * just return the amount of info we're asked for.
>> + * all the arguments, we should just return the amount of
>> + * info we're asked for. The vma is already looked up and
>> + * locked; vma_locked indicates whether the per-VMA lock
>> + * or mmap_read_lock is held.
>>    */
>> -static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
>> +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
>> +		unsigned long pages, unsigned char *vec, bool vma_locked)
> 
> vma_locked is confusing me, since I thought vma_locked == false means
> vma is not locked, but it actually means mmap_lock is taken instead. But
> I am not sure an enum vma_lock_state {VMA_LOCKED, MM_LOCKED} is needed
> here.
> 

Maybe I could directly pass the enum page_walk_lock here?

>>   {
>> -	struct vm_area_struct *vma;
>>   	unsigned long end;
>>   	int err;
>> +	struct mm_walk_ops mincore_walk_ops = {
>> +		.pmd_entry		= mincore_pte_range,
>> +		.pte_hole		= mincore_unmapped_range,
>> +		.hugetlb_entry		= mincore_hugetlb,
>> +		.walk_lock		= vma_locked ?
>> +				  PGWALK_VMA_RDLOCK_VERIFY : PGWALK_RDLOCK,
> 
> An unrelated comment about PGWALK_RDLOCK. Maybe PGWALK_MM_RDLOCK_VERIFY
> is a better name since the code just verifies mmap_lock, unlike
> PGWALK_WRLOCK, which requires vma_start_write(). PGWALK_WRLOCK_VERIFY
> might be better named as PGWALK_VMA_WRLOCK_VERIFY.

Agree, I've thought about it too, but we can do it later.

> 
> Otherwise, LGTM.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> 
> 
Thanks.


