Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89384F364B1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F936B0005; Thu,  9 Apr 2026 16:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D003C6B0089; Thu,  9 Apr 2026 16:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF666B008A; Thu,  9 Apr 2026 16:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD9B86B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:07:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85867B516A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:07:14 +0000 (UTC)
X-FDA: 84640101588.13.6F5DD32
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E6EF240011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:07:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X1l6s9I5;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/noGlVUyCBU9SCMkKfV/73/nLArO8jWoLAogqLw1xDk=;
	b=l7wGMG7HjpoxMBnLsYz2I0lqMJjJwB/NOHTsYM9cdVZmMWN4mC/wcX5nydsDUoTf16Qgeh
	e2onFYtRO8iH2h3hpbjjkUOp60aLfTXk9FgreBg7a66M7B+UbBTmHQb+MpW0f2IkHKxr2Q
	qrRD3NTGxUvAIezG2fudBgY+QX4s5XU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X1l6s9I5;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775765232; a=rsa-sha256;
	cv=none;
	b=CMQhIjsv9ROqiptIPPOFCqUTWXVNRJtt7Qe8vkw8P0MDiWRCNA2hxCCe3sJvwHkw75Og8W
	D+VYphXhcF/0YQRq8jq5Bfkwy0ZdRdm7QskHIQisu1Y8wEPYA9I9r2TO03V96Ssk1htBsq
	5ikua3CsqCgJtr1qcp6G3phKsqGZn9w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775765231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/noGlVUyCBU9SCMkKfV/73/nLArO8jWoLAogqLw1xDk=;
	b=X1l6s9I5RbD4+lCJRKJotirKBBpnCpCPu6kWtOuqov/bGa6GzoH9Wr4Twd06U/HqYNJNFn
	5JjkjOcv+zfQLDCusK6IG29oiVgccQhngAiGC5mLfHtsfCqKDvL39NQ5lgMy1IgYmdNP3d
	b32Jq/UiZQWYrC9ddR+eE4g2cW7OklI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-Mb6zeYHcMg6Rw88-C3vIcA-1; Thu, 09 Apr 2026 16:07:07 -0400
X-MC-Unique: Mb6zeYHcMg6Rw88-C3vIcA-1
X-Mimecast-MFC-AGG-ID: Mb6zeYHcMg6Rw88-C3vIcA_1775765227
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8abb82c27e2so43624726d6.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 13:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775765227; x=1776370027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/noGlVUyCBU9SCMkKfV/73/nLArO8jWoLAogqLw1xDk=;
        b=WFkBOkns+SlBHzWWlms4R95iUgqhnAhy2yKhIoQka/3BIS6H9ykOtiMtPynlOs37TH
         NAnJP11/0PAgx3FXoVNy3NPQt2fUU9E3579WTtneo4Mp+JPiKac9Sb+DrsZmdSe8PhFF
         8v0yY9GR0BXar5o1xDSJGdH6GAECoycvb61dDw3LcPJPueZgA4tqgBiDp8KEcSvNaijk
         d/m0s0cJTC5CT60dRg5M25MzdGrUbA9tByG9I0RNJSa4pW7gtX6+U/NyFd/NtNPvzf0J
         3Sc2GzHx6FpdP5J2AH0SZc642rmF3vVEcXa0jyeRGsaXFsoApuXTEPvgfde5gJDNDrhd
         Bn3w==
X-Forwarded-Encrypted: i=1; AJvYcCVZecr90chYzyzA4LRKDJz/Ohl8hXs0ifdxCCDBsuZ4DQb+pCfnZp0yUokBvkTpo+O4AuEOolE1Nw==@kvack.org
X-Gm-Message-State: AOJu0YzAbPhe5PlEKOn288wvDTQS8/yUx7Np1Icqm2GDog9OAIc6LEs2
	v/2ZX9piYW5uBypohVwYpznz71Hq6B/nVGzv9HEMr/6wAJPFFGlnWN8d8UlXvmrFVnwn/Oi+eCS
	pBQdbiqa/KbE20bQWLtXtkPyvApfOOqzmtcyLf1mV1Mk3tACtAl7X
X-Gm-Gg: AeBDiesG2mmk1chhaHkDwEclDj29iwqxmpWyI0ReMul7LSK73w9ZtILUOtTeqOpC0kP
	x2OFzN0G5/BcRGlbxzEkUlVuYYbwtEuHhUsE/H9upqm5inKpwSsdT4MBy7L1JsGHx4TY8gQtsve
	ChPtdAg5143k9oWuD+QnJrLQ4ZJZpONpf4QTEmrk9RQfoxLv8QmLfFeEI9C5wzd8BA/d6K0nnU1
	5kC/x0UTJU77LR+TZY5UC/dYRmNvdE+4yhxuS+1KY8SuVdaUo/w309ZnGAIOYgYe5w98xHx54hA
	gHbxkmWEtOB64rwonpD7Rpzv7VDCSno5VnVluOK7Nyid4wp42EnWJjnglssv/MGsRJufl8zMuYc
	WFhf/i+/xLWiTwpHFW8aayg+BKUo9kzLMJke0pzFEJJ5ugnjS5dFaOvP4GD4SvCjrh6uMfuU1p6
	a4t6wNHjeGDjwHFA4=
X-Received: by 2002:a05:6214:8093:b0:8a5:104b:e385 with SMTP id 6a1803df08f44-8ac8629b4c2mr2842366d6.35.1775765227226;
        Thu, 09 Apr 2026 13:07:07 -0700 (PDT)
X-Received: by 2002:a05:6214:8093:b0:8a5:104b:e385 with SMTP id 6a1803df08f44-8ac8629b4c2mr2841986d6.35.1775765226718;
        Thu, 09 Apr 2026 13:07:06 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84cffe76sm5587716d6.47.2026.04.09.13.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 13:07:06 -0700 (PDT)
Message-ID: <7830cda5-b3df-4da1-805b-278d5af6b2b1@redhat.com>
Date: Thu, 9 Apr 2026 16:07:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] mm: thp: always enable mTHP support
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
 <772C4431-FA93-4477-B1CE-3BE5EA97FD0B@nvidia.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <772C4431-FA93-4477-B1CE-3BE5EA97FD0B@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0NNP-8RvtU4ntWMdGTO1HMKAkKErjsMSDbcNxTYazOs_1775765227
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6EF240011
X-Stat-Signature: 44pwoc5tpnhfocy8enqfi68rm6kpmhya
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775765231-573067
X-HE-Meta: U2FsdGVkX18J/VbxQmOOGM/kcAke7fDAqr1yf0YMMJ2KMdzywgTigWXKgHiZrW1v8PeLHveaLTLnIaM9pKGRphz8M1DBG/4bOq5clZ9e+c50lgcvZy3HV4XU5oYoXCj17A0ES+pTSXRVWGZsKtakzDmd6hF/9CT7VRrb3uTtQkY5yut9l/fBExrcHdGKrbWlCGfvhV1jaIe7Z3eZiIvwRJO6MsnA5JAXPBri4bIhjADWadp2eOhCB3G7X9I3WqmzlIOfat/8UihBn2Uqoo9WU0pLcvkCI/D8kyjHA3qyRd8rj5sZVAXXZ3RxJEsGp5OWTThJq9/g8Ptkd5+ggM3xanC2xzkfrIQ/XylCI0wFLH+rx1E4J2863rif5qD4RyBYcZttdDx4fQuvj+xDXDRd7g1tw+EK2ZO4ni4DGf4jRJ4qqDHaEf3A1Jft8nyR7oFrQhRX8Y61wcpmNTaFhfLE9kBg3PVAGO9R6XDdKnH/iYeoMnPyugF+i3zEcP5kA8htQJpvA3es1/Y4FsysOLzXVlcWTkz8d2mXaN6bQ5iT2+jL9GHoZsn/QAd+o7buG7tc71/1PATIMq7Eknj/oilW+xrNA/JTI+vL3qatKlOXAug4919X+x4KR/fd2cQaIJpDhiJol7xluJJAcuSjVHn7W67tSSt7r58LvKWKGLfJmvtvY7Q4Cw33Snoy4lKxv5BOuwuZmUbaadRmkMvVBNMm2HWHAyPlChsNhmBLedrRBuwVFGl4XBauIADQ9vritpeiH+EG+/Q7WUMW047e0SlEcHQwgVuqUrBymO+F+jqB0Fj05iwwE1x21QSw7INQdZnTv5jdyGeeru8RqzsPwd51pORqYuC9lZ12FKl+GXpBvA/POadfqLk5p9OjQc+6p/dUmzNLUSGAPcf2WLVKRDdo2ivmFjVagILuf8tJM8BX8t6Owtv22+gPKHHn9+AoxbIFnWp9fBSEgLG54ttEOI2
 5IV63CGj
 IXG5tttW4lcaolrHx/6kV8E4cTEN5vli6g8SAOqguhYtkq7UqfhYrCRJeZLuaYoD+VEJn3SvAUoFtpoR2k2ZEtRwwbv8scqhRPM3SxCro9Qsdak9W30/BafQ84YjA9Vumi/DcLeYRmFjpJBXAaFkHxDOsj5DRyoNl/ko6A1uvFFUTQGejreYBONWLhIT7RmPwQ/ZG/iD5obu9WiDKIL8cYkxUQ1H9MhyryOWEmhNVNmJZrLJ4eCYuTHMZ6txweoj5cc+4f+tx71qbH9hqhdbIM8lznJZiDjpSLndlXkYbXZI6NagrT4dd5xvZhJsatUbdh2aqT6aZL1hA1u8G/dRzHDUYTWwGXSQ9sWEI1ZHmuSwMEz2Z521uzmDOzzgjmSzeA4vUCtYaa6nSk+Bg8xG4ev7azw3ORQSGa24xThIPlbEu4n24+rh66KoSfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 11:55, Zi Yan wrote:
> On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:
> 
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem:
>>
>>   - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>>     check so that mTHP sizes are considered
>>   - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>>     when PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 13 ++++++++-----
>>   mm/shmem.c       |  4 +++-
>>   2 files changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 86e489c0a150..6de3d8ebc35c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   	else
>>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>
>> +	if (!pgtable_has_pmd_leaves())
>> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> 
> Why is BIT(PUD_ORDER) also removed? I thought PMD THP support and PUD THP support
> are separate. Here the code implies PUD THP relies on PMD THP. Is that the case?

This was a suggestion from David to an earlier version:

https://lore.kernel.org/linux-mm/dac20466-adac-4e47-8f50-87f4774fd57b@kernel.org/

My understanding was that if an arch doesn't support PMD pages then it
probably doesn't support PUD pages either.

>> +
>>   	orders &= supported_orders;
>>   	if (!orders)
>>   		return 0;
>> @@ -125,7 +128,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   	if (!vma->vm_mm)		/* vdso */
>>   		return 0;
>>
>> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>   		return 0;
>>
>>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -787,7 +790,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>   	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>>   	 * constant so we have to do this here.
>>   	 */
>> -	if (!anon_orders_configured)
>> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>>   		huge_anon_orders_inherit = BIT(PMD_ORDER);
>>
>>   	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>> @@ -809,6 +812,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>   	}
>>
>>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +	if (!pgtable_has_pmd_leaves())
>> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +
> 
> Ditto.
> 
>>   	order = highest_order(orders);
>>   	while (orders) {
>>   		thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -908,9 +914,6 @@ static int __init hugepage_init(void)
>>   	int err;
>>   	struct kobject *hugepage_kobj;
>>
>> -	if (!pgtable_has_pmd_leaves())
>> -		return -EINVAL;
>> -
>>   	/*
>>   	 * hugepages can't be allocated by the buddy allocator
>>   	 */
> The code after is:
> 
> MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER > MAX_PAGE_ORDER);
> 
> Should this check be removed or only performed when pgtable_has_pmd_leaves()?
> 
> I do not know if there is a possible Kconfig that lowers MAX_PAGE_ORDER
> below PMD_ORDER and enables THP. After this patchset, that might be valid
> if people do not want to use mTHP but not PMD THP.

I need to look into this more carefully to be able to answer this, I'll
get back to you.

>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 613393eae5a9..b49a30475cb0 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1839,7 +1839,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>>   	unsigned int global_orders;
>>
>> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>   		return 0;
>>
>>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>> @@ -1947,6 +1947,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>
>>   	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>   		orders = 0;
>> +	else if (!pgtable_has_pmd_leaves())
>> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> 
> Same question as the first one.
> 
>>
>>   	if (orders > 0) {
>>   		suitable_orders = shmem_suitable_orders(inode, vmf,
>> -- 
>> 2.53.0
> 
> 
> Best Regards,
> Yan, Zi
> 


