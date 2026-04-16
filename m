Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACA7F433D2
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 00:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06606B0005; Wed, 15 Apr 2026 20:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7546B0088; Wed, 15 Apr 2026 20:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A62E6B008A; Wed, 15 Apr 2026 20:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76E396B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:49:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6078BA6C0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:49:44 +0000 (UTC)
X-FDA: 84662586288.24.210B82B
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8686380008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:49:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=al0GMVKG;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776300583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMDkB3M6DeO+x7rz8eUh1YbTs7caB4nDxuzSIvsHJSU=;
	b=V3V2wr2QLBHlorZpugSes9z/OhW8snPkJ4XOHyJZALPqOo/FMeriSMrDg1i62zsu0hpOY3
	NIC1yXtZc/C27CLx0oHQ+5hFyw6Eqm7V4iykAiQruppYQB9N6PvKzXknMOgpY1xljTQKAX
	b1Rbq+YSRBcCqVqGsydydWqmjYNNuHQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=al0GMVKG;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776300583; a=rsa-sha256;
	cv=none;
	b=bBkKZOyRFTonlFL1UcFdLBG/DJfYV6Z96bRwswWdbxMy8NAVw7gXECundkVkPGoJb+Xf5Z
	MeMNKCwNyKHYbeJa0czaVO8rklV0S/6neNNtLhvlZ5M2ZavKCF4HGhF9qOYFp4ugfGbkDR
	Kp5A+StA9YXx6M6c22lXShBL7OHmvBw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776300578; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wMDkB3M6DeO+x7rz8eUh1YbTs7caB4nDxuzSIvsHJSU=;
	b=al0GMVKGONtLy/MIKAKvKxomn3g5aP5ZgkbiTifzboRHalvQFWS0I8Cy+KYTQMQB3dYg1rNGqN3QJh0qgt2DZ6SMCkoviAjIUQ6snrWvbuhNYmuBzS3t6R12zcJjE5+TqbML3r9uQdwfVe8vFI/c03ereYHAkF4mzPs2NyCphCY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1680nn_1776300576;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1680nn_1776300576 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 08:49:37 +0800
Message-ID: <9c6e376e-1a91-4aaa-9918-ca161fe57130@linux.alibaba.com>
Date: Thu, 16 Apr 2026 08:49:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
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
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
 <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
 <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8686380008
X-Stat-Signature: exky3r44piqwur5raqf3zcx5eqch9myo
X-Rspam-User: 
X-HE-Tag: 1776300581-376210
X-HE-Meta: U2FsdGVkX19xvtyplCifL9+6d0nVwQRKfzsolv0EehKlOKRJEezuHOEJ5xvUa+yDrrCk59yISDtHOt+P5yLrk/o22RdO+61OG6p/jAUjzuLO16xMoAxLGvhL54QSYn4GN5bbDU/8PchvpQb5HnBKix6YVQ0a1DCA4vLa8KuDH5/K7j6hnrq2hqOZWILY8FjTO5Z58OxhHaMH+7WSUYbk8ZhG+u3AvkqkyBadO1xfkv0PUEwOiwjFALMiEBVOL/0g0858gHk8hsh8tuEyog3HAHtGhNAJzsr3+7BHE7pIxCF6OE9CO3MZMxX7Lexe9XaEzO52qEla/3J/sHn93btsAQTLf5a8NzCDwz8pM8yGFkushOr6KI4vJXxwKYBnYpeNUF+k0npWW9+FuyyOSDtR5W1mNsC9xC4cQ039e0+43Zblpu8SCCH10O/DnxX26+3X8rFayR5wTisDK3P7JF+/SII9MozcMayFg1Gs6aQKUH8aWvlKYDSh6pWLSoOe+cfodTeYK5J/YeQ9gymHmTzPldQ+mBVjy/GxZhRv7Kq1M3UkDjGC0/bd27hWgAzmfDOotvAS7Z8vm70tfVLb6gQZBWmwxG+zbF7IfVRl/JQ6YyZwAIa+aZ6b+cEEvAmH2UQwnc2TlCl/UruwuoOjd+A0NOMsLUETcxS24oMiYPt+faXkkJRQP3VcaPJdUDoJoyhBgqbM8fm56MrU7j4TvEwUXlWHGPMzy7zMsULYyhkYfOnp3TkV/FDyYxOvg9Yih33HT+uDJeeKF5y2r5hxMQp/dia1ooyBszRxHw2Iej53oHoiGzkOsse6JXWxg0SY4VcUUNEr/HkAs57Cj5rI4m6TzMPxmJjU0/KVAJWHfdeLLSlshhuo4Am1akbD6V0qE8pjxBxeh4PLWuLHQdlSWl3NxBKdRKxATmX2CAePnoLqxCDmvr9/GjV/AXJ6uMmK41Lz5RQI/OiMlfbSlkOdZB+
 DO0uEti1
 ypG948zQNnTiewBr+fOjwrcoT9vLApPQJnJY66emBQg4+pVMrXeeQfFHc4M99QEQssDs2IgSO7A6NmIC6iYoHzVNK8kTZGse2Oa3CCFyODgS2XN2gKr0Y4hsGlWawW8GbDZZUDDT2nwFPKKD8/XScguVnM36PNjOSxKaFPVWPl1yW42a8J/1aAZVNJUM0XjmV8X9YQ8SQi2Xe8KgJq+Dw649f8XFLPetF3NaUIURNt126y2NWn75Eaa8igrHwYsP/SbCF6XdkGVg5FCmUiOmXPoK8y76RdeviGZ0jBBx1XzzKzR4zDjxooGDMPGiHHNvfyKKtKBOLkJauexBn/LacIJ8e0IyYc0Ulz2jQ0F6LBBGpa0Fu8L/lh/Bci8eWL09TznVg2YKGc/0B+AWmh/sV8mqqLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/16/26 2:01 AM, Zi Yan wrote:
> On 15 Apr 2026, at 5:21, Baolin Wang wrote:
> 
>> On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
>>> On 4/15/26 08:36, Baolin Wang wrote:
>>>>
>>>>
>>>> On 4/15/26 2:25 AM, Zi Yan wrote:
>>>>> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
>>>>>
>>>>>>
>>>>>> Yeah, it would be better if we could avoid it. But the dependency on the
>>>>>> global toggle as it is today is a bit weird.
>>>>>>
>>>>>>
>>>>>> I don't think there is other interaction with FS and the global toggle
>>>>>> besides this and the one you are adjusting, right?
>>>>>>
>>>>
>>>> I'm afraid not. Please also consider the per-size mTHP interfaces. It's
>>>> possible that hugepage_global_enabled() returns false, but
>>>> hugepages-2048kB/enabled is set to "always", which would still allow
>>>> khugepaged to collapse folios.
>>
>> My comments are in reply to Zi’s comment:
>>
>> "I think hugepage_global_enabled() should be enough to decide whether khugepaged should run or not."
>>
>> I’m concerned that only relying on hugepage_global_enabled() to decide whether khugepaged should run would cause a regression for anonymous and shmem memory collapse, as it ignores per-size mTHP configuration.
>>
>>> The question is really which semantics we want.
>>>
>>> Right now, there is no way to disable khugepaged for anon pages, to just
>>> get them during page faults.
>>
>> Right.
>>
>>> And we are now talking about the same problem for FS: to only get them
>>> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FOR_FS).
>>
>> OK. I’m fine with using hugepage_global_enabled() to determine whether khugepaged scans file folios.
>>
>> My concern is that for anonymous memory and shmem, the per-size mTHP settings should be considered.
> 
> OK, I misunderstood the meaning of hugepage_global_enabled(), since per-size
> mTHP settings could also enable khugepaged if PMD_SIZE is set.
> 
> I will take willy’s original suggestion and make khugepaged on if the global
> setting is enabled. The below is the new version of this patch. I moved anon
> pmd huge page code to a separate anon_hpage_pmd_enabled() like
> shmem_hpage_pmd_enabled() and cleaned up the comment. Let me know your thoughts.
> 
> Thanks.
> 
>  From 92b92f2b2ab41c70b41dd304ce648786ee6a1603 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 15 Apr 2026 13:52:50 -0400
> Subject: [PATCH] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>   hugepage_pmd_enabled()
> 
> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
> hugepages are enabled by the global transparent hugepage control.
> khugepaged can still be enabled by per-size control for anon and shmem when
> the global control is off.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/khugepaged.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..586d27ce896e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>   }
> 
> -static bool hugepage_pmd_enabled(void)
> +static inline bool anon_hpage_pmd_enabled()
>   {
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
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>   		return true;
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> @@ -425,6 +415,20 @@ static bool hugepage_pmd_enabled(void)
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>   	    hugepage_global_enabled())
>   		return true;
> +	return false;
> +}
> +
> +static bool hugepage_pmd_enabled(void)
> +{
> +	/*
> +	 * Anon, shmem and file-backed pmd-sized hugepages are all determined by
> +	 * the global control. If the global control is off, anon and shmem
> +	 * pmd-sized hugepages are also determined by its per-size control.
> +	 */
> +	if (hugepage_global_enabled())
> +		return true;
> +	if (anon_hpage_pmd_enabled())
> +		return true;
>   	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>   		return true;
>   	return false;

Thanks. Looks reasonable to me. Let’s also see what David thinks.

