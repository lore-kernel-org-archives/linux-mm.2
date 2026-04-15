Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC8BFA0C32
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F74B6B0092; Wed, 15 Apr 2026 02:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8815E6B0093; Wed, 15 Apr 2026 02:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FDF6B0095; Wed, 15 Apr 2026 02:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6220E6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:36:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 007C38B5AA
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:36:49 +0000 (UTC)
X-FDA: 84659832138.15.35C0718
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9B1B21C0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:36:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Opyics49;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMt2bIr3uHYCeh2UEv9xowcJHrgLSmG6Qr3AzYVzrEw=;
	b=Nhr2BYQIiP5DXxMvpZfNbV9ewyW38xbOyxbV9URzO+EWIlOFOoQSwctiWQj8gHfQfM5Dx5
	TW0Up/FVAnVMP/FBpsoY1SlpRbtEny+7jK91Cq+ifvw+7pGhccBv3vB8ZCOqRi8H9CDug0
	1DGyF2y2avzB/Xh/5JiK+l7vANqkUBo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Opyics49;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235007; a=rsa-sha256;
	cv=none;
	b=pIJCH6AIbl9YoIxVRX114Hg3mFBq1KaXQD75iDkcpjMRIYmufK9l7X9gHUQ8Evf1VWYa4R
	MoH/WZF6KXHaDqtZPhYETuok71t6RczgaQom8CsGnV9Jtyo3Xd4RkG78sq5RkEEbNzzzF6
	RE0eKKJZGYmwVgQtdyECnf0KqAr4OT4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235002; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gMt2bIr3uHYCeh2UEv9xowcJHrgLSmG6Qr3AzYVzrEw=;
	b=Opyics49HSIAbdr8arLGTplTsvRkuFUbVS83HEuZaZ8rRDCUeY0JPmio/BSb3qWrcK6SEbm3PhwLF9zzZPhq8wPM+vh+6bNY9c/H2OM3o6tdeJsrow6o34JL2wp8rwM7V9gPGgY8kAtt3Jm11Dr0heR9FsSjxeT36wNuqAomjAA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13dW0z_1776235000;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13dW0z_1776235000 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:36:41 +0800
Message-ID: <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:36:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B1B21C0008
X-Stat-Signature: xrecayti9xb5pdfuwqm375mpacczj96t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776235006-741975
X-HE-Meta: U2FsdGVkX19HgYXKJWRVeWwu0S+W73+JD1pMPiJLIT96nRRCu+TEM9WKnW34ID691LCteP5FIjcO3AujpnFNMn61oziU3mImkLfbGYNQoiPryVN8ef+mdniSYwNa0tfEGc7aeVL3ofTmeG2IqR6ne90kz0iQSltD3E5wQ5ov+qZqgxY0YrsMDGiGz6sbJ1caPe5H9myV6g6xpTO2kTt6log/noqjUBFNtDBZbhJlQIGx6iu3XmC8NqKNLzW2WoMiCMPWnOfVxY+5whQIG6UR0W6lQKAsfC7dHuLvVcbHZdxC7nXrCN6B0BdjWFotEn21ka4oa0nssCKP/k8RUkkjfSIk8cTqqNvENVxANWE7p5U2QM932XYWcidjqo4j+uEzov1hBhjeZmveaUovfBpG0bEO2QEV5STlnezACf3vpZiAniXA6RnWi5Cp9zQNxOaOt+YavKNljrFYPh2X0aaPXeLr+s61jz/apsojC88MTCUnE/BgAqjSETv9Lpd3AiIXM9oHfyGokZ/vQIe0uik9fPR0lHMrAPtEDHBmgLjqgdGjztCH5DIUkem/JcQxitwwkU7DiEzSKj2uhH2IzCWpbZxLw6m0ubDTQHb8ETDqtmangLiEkN2k5NLrMT7q20CUf8ITyyNzBhJuofkbs7m+bjXHFlJw9UH+7AAgWxQc0JXxY0iv83bYTfJw1WWSgLyNjzaDoin4Jr83DXCZMioZDTtIbKvqWpE8MOAWXhENEDt5iJUrmt4kR8wWFU2lHWFCFgwPuADzJ7pPK8uhTU/m7W/bngT5Cd6TMQD6X9ob9o6SLWoVi+mhaU/qrbhM+Ay2Xefu0ecqcYt/DBzDjkpwBpuiBDaPoevEwb8/ZRhyBr4wg58mjfk2PSVlvnrHaRgPU7F6GsJQwBZwJNLtbx0+hfAB0Yq/212OA+HmLnSzqQnIEMH/KzAz/ccsIe0bU/RDYZ+CJyRJiQ/CPvLxtiM
 WsHSTXfJ
 YItXlCX2wBdkqmGJaYkMtI2BPpc2S2PoH3cNAcgckh/Uj6vlfxLMiPq5XcmQMf9CJUZsJLirlRPK6OzA1ihEbZgOkGHN7y3rU3uziPykqsLbAzmpgBwekRGcuJN/Klokukdu94+AbU47OlA8ZaL6eV99Kmopzgt3bL6+cXMfkXYIy0EnQkWBIiusoOpvEVjGe14qCB3RY+agHUI1Fk497VlhuWmtpgZVG2Pae8t3ixH8mIrqV/nkKpFlcLHLg9FiyJHlWiy01SKc4dBs7DBMMIapHv7y0OmwaNJsjCh1Ws3LflTP8eE2P9cNPCLyjuUgosvOPnc84VaVoXFxhWwU4f7euZ6magVF3mI0nKwAQPghDoMVyDPEGFffEut0NVxBRAb3CEr82cqhrTdH8TGsRoFh/jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 2:25 AM, Zi Yan wrote:
> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
> 
>> On 4/14/26 18:30, Zi Yan wrote:
>>> On 14 Apr 2026, at 7:02, David Hildenbrand (Arm) wrote:
>>>
>>>> On 4/13/26 22:42, Zi Yan wrote:
>>>>>
>>>>>
>>>>
>>>> I assume such a change should come before patch #4, as it seems to affect
>>>> the functionality that depended on CONFIG_READ_ONLY_THP_FOR_FS.
>>>
>>> If the goal is to have a knob of khugepaged for all files, yes I will move
>>> the change before Patch 4.
>>>
>>>>
>>>>> I thought about this, but it means khugepaged is turned on regardless of
>>>>> anon and shmem configs. I tend to think the original code was a bug,
>>>>> since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
>>>>> the time.
>>>>
>>>> There might be some FS mapping to collapse? So that makes sense to
>>>> some degree.
>>>>
>>>> I really don't like the side-effects of "/sys/kernel/mm/transparent_hugepage/enabled".
>>>> Like, enabling khugepaged+PMD for files.
>>>>
>>>
>>> I am not a fan either, but I was not sure about another sysfs knob.
>>>
>>
>> Yeah, it would be better if we could avoid it. But the dependency on the
>> global toggle as it is today is a bit weird.
>>
>>>>>
>>>>>
>>>>> Alternatives could be:
>>>>> 1. to add a file-backed khhugepaged config, but another sysfs?
>>>>
>>>> Maybe that would be the time to decouple file THP logic from
>>>> hugepage_global_enabled()/hugepage_global_always().
>>>>
>>>> In particular, as pagecache folio allocation doesn't really care about __thp_vma_allowable_orders() IIRC.
>>>>
>>>> I'm thinking about something like the following:
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index b2a6060b3c20..fb3a4fd84fe0 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -184,15 +184,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>>>                                                     forced_collapse);
>>>>
>>>>          if (!vma_is_anonymous(vma)) {
>>>> -               /*
>>>> -                * Enforce THP collapse requirements as necessary. Anonymous vmas
>>>> -                * were already handled in thp_vma_allowable_orders().
>>>> -                */
>>>> -               if (!forced_collapse &&
>>>> -                   (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
>>>> -                                                   !hugepage_global_always())))
>>>> -                       return 0;
>>>> -
>>>>                  /*
>>>>                   * Trust that ->huge_fault() handlers know what they are doing
>>>>                   * in fault path.
>>>
>>> Looks reasonable.
>>
>> I don't think there is other interaction with FS and the global toggle
>> besides this and the one you are adjusting, right?
>>
>>>
>>>>
>>>> Then, we might indeed just want a khugepaged toggle whether to enable it at
>>>> all in files. (or just a toggle to disable khugeapged entirely?)
>>>>
>>>
>>> I think hugepage_global_enabled() should be enough to decide whether khugepaged
>>> should run or not.

I'm afraid not. Please also consider the per-size mTHP interfaces. It's 
possible that hugepage_global_enabled() returns false, but 
hugepages-2048kB/enabled is set to "always", which would still allow 
khugepaged to collapse folios.

>> That would also be an option and would likely avoid other toggles.
>>
>> So __thp_vma_allowable_orders() would allows THPs in any case for FS,
>> but hugepage_global_enabled() would control whether khugepaged runs (for
>> fs).
>>
>> It gives less flexibility, but likely that's ok.
>>
>>>
>>> Currently, we have thp_vma_allowable_orders() to filter each VMAs and I do not
>>> see a reason to use hugepage_pmd_enabled() to guard khugepaged daemon. I am
>>> going to just remove hugepage_pmd_enabled() and replace it with
>>> hugepage_global_enabled(). Let me know your thoughts.
>>
>> Can you send a quick draft of what you have in mind?
> 
>  From ee9e1c18b41111db7248db7fb64693b91e32255d Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Tue, 14 Apr 2026 14:17:31 -0400
> Subject: [PATCH] mm/khugepaged: replace hugepage_pmd_enabled with
>   hugepage_global_enabled
> 
> thp_vma_allowable_orders() is used to guard khugepaged scanning logic in
> collapse_scan_mm_slot() based on enabled THP/mTHP orders by only allowing
> PMD_ORDER. hugepage_pmd_enabled() is a duplication of it for khugepaged
> start/stop control. Simplify the control by checking
> hugepage_global_enabled() instead and let thp_vma_allowable_orders() filter
> khugepaged scanning.

It appears this would prevent shmem collapse, since 
hugepage_global_enabled() doesn’t consider the THP settings for 
shmem/tmpfs (only for anonymous memory).

> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/khugepaged.c | 36 ++++++------------------------------
>   1 file changed, 6 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..459c486a5a75 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -406,30 +406,6 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>   }
> 
> -static bool hugepage_pmd_enabled(void)
> -{
> -	/*
> -	 * We cover the anon, shmem and the file-backed case here; file-backed
> -	 * hugepages, when configured in, are determined by the global control.
> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> -	 */
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> -		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
> -		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> -		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
> -	    hugepage_global_enabled())
> -		return true;
> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> -		return true;
> -	return false;
> -}
> -
>   void __khugepaged_enter(struct mm_struct *mm)
>   {
>   	struct mm_slot *slot;
> @@ -463,7 +439,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>   			  vm_flags_t vm_flags)
>   {
>   	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> -	    hugepage_pmd_enabled()) {
> +	    hugepage_global_enabled()) {
>   		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
>   			__khugepaged_enter(vma->vm_mm);
>   	}
> @@ -2599,7 +2575,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> 
>   static int khugepaged_has_work(void)
>   {
> -	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
> +	return !list_empty(&khugepaged_scan.mm_head) && hugepage_global_enabled();
>   }
> 
>   static int khugepaged_wait_event(void)
> @@ -2672,7 +2648,7 @@ static void khugepaged_wait_work(void)
>   		return;
>   	}
> 
> -	if (hugepage_pmd_enabled())
> +	if (hugepage_global_enabled())
>   		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
>   }
> 
> @@ -2703,7 +2679,7 @@ void set_recommended_min_free_kbytes(void)
>   	int nr_zones = 0;
>   	unsigned long recommended_min;
> 
> -	if (!hugepage_pmd_enabled()) {
> +	if (!hugepage_global_enabled()) {
>   		calculate_min_free_kbytes();
>   		goto update_wmarks;
>   	}
> @@ -2753,7 +2729,7 @@ int start_stop_khugepaged(void)
>   	int err = 0;
> 
>   	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled()) {
> +	if (hugepage_global_enabled()) {
>   		if (!khugepaged_thread)
>   			khugepaged_thread = kthread_run(khugepaged, NULL,
>   							"khugepaged");
> @@ -2779,7 +2755,7 @@ int start_stop_khugepaged(void)
>   void khugepaged_min_free_kbytes_update(void)
>   {
>   	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled() && khugepaged_thread)
> +	if (hugepage_global_enabled() && khugepaged_thread)
>   		set_recommended_min_free_kbytes();
>   	mutex_unlock(&khugepaged_mutex);
>   }


