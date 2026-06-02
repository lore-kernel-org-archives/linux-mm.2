Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFAFCD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F355F6B04A5; Mon,  1 Jun 2026 23:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CEA6B04AA; Mon,  1 Jun 2026 23:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E485B6B04AC; Mon,  1 Jun 2026 23:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3D276B04A5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:02:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F6861A0768
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:02:19 +0000 (UTC)
X-FDA: 84833473998.02.F5A8F83
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E4D940009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:02:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="nfhegle/";
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780369337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSTQRXqZkfE0CBpGC79lm3NY6Rv+5Tj1N3miINFndqA=;
	b=ZAeI/2bVm3LQGq/PdHgpxJaycWiwyDDdht/j0wit3uphQ0TpuSUKUh5Q0uH3OG5rSpS/f9
	0suRAacdV+nrHVvlyzm20JmlL0785Vl0kOUJ55VF5VpuwwwUt0o3ni6F0txjNtFf0TiKCq
	UUQWEUine6gjuXsL2IPB5dPBvsb1l4o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="nfhegle/";
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780369337;
	b=CSHOjpyByCgVaAiTULOlN+hqAZjctOTbizqtdiNVrakp+NKzVREDPbvBwavSfte3U6LbWV
	oOMaTiAflnIIwrjVJRo/TAowhmjzOWF4Mh9edwGGOMXTG6Nj3hbdgHNeAWrr7CVntsgKeC
	C+cBzVf4U+wGdQvqIhK7h/MY7e2yZ3w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780369332; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=CSTQRXqZkfE0CBpGC79lm3NY6Rv+5Tj1N3miINFndqA=;
	b=nfhegle/8ZTeP3zpUWf0onx0vAvPx4PVCXKI/K/J3shCN+NA2hsauRWbMRDT+RMOokmkZ6GdMC0hjlN9IgFzfcpFJCMidHbCgftLS04SgaA3RiNbpThyIUEMzvREstepOE9ogti7C2MyD/i4IPRppXtALw8VMRj7xZ5kP3IM28c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X42mreA_1780369330;
Received: from 30.166.17.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X42mreA_1780369330 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 11:02:11 +0800
Message-ID: <5e4defef-8967-4cdf-9123-07dd9517d637@linux.alibaba.com>
Date: Tue, 2 Jun 2026 11:02:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
 <7b3e5fd9-e0d6-4c0d-8656-2649855f4034@linux.alibaba.com>
In-Reply-To: <7b3e5fd9-e0d6-4c0d-8656-2649855f4034@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E4D940009
X-Stat-Signature: 44yq4rr8jboyrdeatekqbuxn3qi6mwgi
X-Rspam-User: 
X-HE-Tag: 1780369335-526455
X-HE-Meta: U2FsdGVkX1/jg1HsB/j5sDkKD+tFoQRpfExSOYpVllZ2UMSOcng/T0n0rDKcqGNd2o3QFYi/iQEHExCj9yX8pdSA6+Fzp4ZgraasPkzLC2TeYGc4Y2kFNopIo8A0wZZTbiyyEcKtScswWziRg+QQHltIwSTS9Jhym9zOdheOYEWem8Y0d7I6HX6jUl+GwKmXqpdjggf68dnKE9l5tjjbqIELIRQueDfqVJII4Ssb0mKTiiO/iLGIuahhgoSutt90Iat1+M4NCiKZGYVRIQx0NXxsldKMlNDLhpTjZd79lcBZPiF6SQJL+F+MuLp8OD6JFZDxpPr5Mf/BYz/UQBy8uTDSrYt+WweLFzZxZLqCvkuw2+Wb5m6En+N6DPnaAPnS2KVXq1uZr1x41aWiueBSPHdwhya71w7HmMuSYUQb1gm/tYzTfRynEtanlTpxqIxJCV66yl9UAb+3xQymvHtm0HWePC0s7jDuveuSer8Lkbx4fEjByxbVBol4zSqbARXicydRcurSrhzOgLxzQTkEozK/hZ+gfwUL8lOydGSVcbpT7KXMY0uz2RaQlKwkJiz2eMF7NkmOCeyBR2x2QIK+JRDvNg9rd/T9vKkQYXxLJuLpzX8NlvakI0uMMPHCIGmwbMX9FD5ifEymk7XGSI+peMgqWJXY1upj6Uu7hdpJrg3RW0vKMih8BJIl2+xvm5TA+jpEX2FhpSlKsFIdQ4PoSKnmIkR7Pq6U4BSc2GVSVeuE0SHSkwxh/M04PQpNBEaLk/EuMEKEOP2J5+TZUzpaCmA/xaLjSlGask/yvuCJw6+8kwg05UIiLy3J1YAqcQsAv2X2K1rwhHaepy9DqObBrlg+L8TKYxC5bll7sIUPEKKAIecnn/5mSDWzIsP2Wis5Ryopjw59Bs2Sy9gwsLnnMKrLQRYnDRTm8yeMHR2QGFJ3Pgz/ZOHBRGGOwkzZz980RFg/QiOlUruAazk1ksR
 z6qsBnIZ
 eCxKBsXWIMWCCyNu400K/N8CsoiAmbwMLq51c3Rq/JpRRGE2JyLotqb5ZVogZHzapXD83U/+nFNphmfsfRSePOyRUDV1mE4dh1QFt32hXTb9+uwK67VrxXhg7nPvamyj/niYEAT27svhek5HysGXi8THZEn67slUnsdrE/PcrtrQU4xFS2i9aKhvov64myWwdcN65TmK4ObOMNMJjM+Oog8ZejWQlAUnuqct2onGTstjQYgRw6HBg5miDeHJ26Yc6czDRctHilo1rb14q4Gtn/mB1Z+xAUEAW5WLp6lVPoBGBMzwmdAc6eApfPpcmPRrTry9KqcEyjPCoj8tMAOxB+GyajgTSeE+HezRakG46HD2sGmAiAg7N8h51nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/1/26 8:02 PM, Baolin Wang wrote:
> 
> 
> On 5/29/26 10:55 PM, Luiz Capitulino wrote:
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem in
>> shmem_allowable_huge_orders():
>>
>>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>     considered
>>   - Filter out PMD and PUD orders from allowable orders when
>>     PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 25 ++++++++++++++++++++-----
>>   mm/shmem.c       | 14 +++++++++-----
>>   2 files changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 32254febe097..059901a8c6cb 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -126,6 +126,15 @@ unsigned long __thp_vma_allowable_orders(struct 
>> vm_area_struct *vma,
>>       else
>>           supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves()) {
>> +        /*
>> +         * If the CPU does not support PMD leaves, assume for
>> +         * now that it does not support PUD leaves and disable
>> +         * both folio orders.
>> +         */
>> +        supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +    }
>> +
>>       orders &= supported_orders;
>>       if (!orders)
>>           return 0;
>> @@ -133,7 +142,7 @@ unsigned long __thp_vma_allowable_orders(struct 
>> vm_area_struct *vma,
>>       if (!vma->vm_mm)        /* vdso */
>>           return 0;
>> -    if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, 
>> forced_collapse))
>> +    if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>           return 0;
>>       /* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -848,7 +857,7 @@ static int __init hugepage_init_sysfs(struct 
>> kobject **hugepage_kobj)
>>        * disable all other sizes. powerpc's PMD_ORDER isn't a compile- 
>> time
>>        * constant so we have to do this here.
>>        */
>> -    if (!anon_orders_configured)
>> +    if (!anon_orders_configured && pgtable_has_pmd_leaves())
>>           huge_anon_orders_inherit = BIT(PMD_ORDER);
>>       *hugepage_kobj = kobject_create_and_add("transparent_hugepage", 
>> mm_kobj);
>> @@ -870,6 +879,15 @@ static int __init hugepage_init_sysfs(struct 
>> kobject **hugepage_kobj)
>>       }
>>       orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves()) {
>> +        /*
>> +         * If the CPU does not support PMD leaves, assume for
>> +         * now that it does not support PUD leaves and disable
>> +         * both folio orders.
>> +         */
>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +    }
>> +
>>       order = highest_order(orders);
>>       while (orders) {
>>           thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -969,9 +987,6 @@ static int __init hugepage_init(void)
>>       int err;
>>       struct kobject *hugepage_kobj;
>> -    if (!pgtable_has_pmd_leaves())
>> -        return -EINVAL;
>> -
>>       /*
>>        * hugepages can't be allocated by the buddy allocator
>>        */
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 079e299ea789..c15dffd0eb41 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1844,16 +1844,19 @@ unsigned long 
>> shmem_allowable_huge_orders(struct inode *inode,
>>       unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>>       unsigned long within_size_orders = 
>> READ_ONCE(huge_shmem_orders_within_size);
>>       vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>> -    unsigned int global_orders;
>> +    unsigned int global_orders, disabled_orders = 0;
>> -    if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, 
>> vm_flags, shmem_huge_force)))
>> +    if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>           return 0;
>> +    if (!pgtable_has_pmd_leaves())
>> +        disabled_orders = BIT(PMD_ORDER);
>> +
>>       global_orders = shmem_huge_global_enabled(inode, index, write_end,
>>                             shmem_huge_force, vma, vm_flags);
>>       /* Tmpfs huge pages allocation */
>>       if (!vma || !vma_is_anon_shmem(vma))
>> -        return global_orders;
>> +        return global_orders & ~disabled_orders;
>>       /*
>>        * Following the 'deny' semantics of the top level, force the huge
>> @@ -1867,7 +1870,7 @@ unsigned long shmem_allowable_huge_orders(struct 
>> inode *inode,
>>        * means non-PMD sized THP can not override 'huge' mount option 
>> now.
>>        */
>>       if (shmem_huge == SHMEM_HUGE_FORCE)
>> -        return READ_ONCE(huge_shmem_orders_inherit);
>> +        return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>>       /* Allow mTHP that will be fully within i_size. */
>>       mask |= shmem_get_orders_within_size(inode, within_size_orders, 
>> index, 0);
>> @@ -1878,6 +1881,7 @@ unsigned long shmem_allowable_huge_orders(struct 
>> inode *inode,
>>       if (global_orders > 0)
>>           mask |= READ_ONCE(huge_shmem_orders_inherit);
>> +    mask &= ~disabled_orders;
>>       return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>>   }
>> @@ -5461,7 +5465,7 @@ void __init shmem_init(void)
>>        * Default to setting PMD-sized THP to inherit the global 
>> setting and
>>        * disable all other multi-size THPs.
>>        */
>> -    if (!shmem_orders_configured)
>> +    if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>>           huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>   #endif
>>       return;
> 
> Seems we should also filter the PMD-sized order in shmem_getattr() if 
> pgtable_has_pmd_leaves() returns false, like I mentioned in the previous 
> link[1].
> 
> [1] https://lore.kernel.org/linux-mm/6591a74c-7ef9-4614-9ae9- 
> cb2fbed86ebf@linux.alibaba.com/

You already did this in patch 7. So LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

