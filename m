Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C6ACA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 12:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E1B6B008A; Thu,  8 Oct 2026 08:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D086B008C; Thu,  8 Oct 2026 08:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FBDF6B0092; Thu,  8 Oct 2026 08:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6E66B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:08:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF97480165
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:08:27 +0000 (UTC)
X-FDA: 85299336654.01.F8CCF0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41F9D1C0002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:08:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X2YG53XC;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791461305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uI+XtiazTVe8pG8BiMyn92RVBJ4I25dozIom7amZQ6c=;
	b=I5sAsUVDrS5rS8zOYqvu5upIzB01WIrwj5+OjzvdvzARE1HCUZeihFo4KAGZNt/RZyNyY7
	qziaaVlcyEc3hql9nZ8Z7L1fn1G0iMruE7Q/M22eXOe4rLMJsg/2vT+sJGBdPreX54sqC9
	obHM0MMNjebqDtMsAzG/XbHuJBp728Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791461305;
	b=E+OQ3JlX0XqKkgGLmcLSSkOJfJ9qTLd5j6HLCG9Ue1/rzeYW7r/fE18wdEMdXYl+NcfnqM
	G4MKnoCyDnnz3N0XJ+YXWnXUItxJPJmojEnxGDGExIjQgnCjzAlchI5xXfiQwfKD+Hla4w
	xhoX9thQGKnMQaOGCZmZT/Mg7EKH9Bc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X2YG53XC;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791461304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uI+XtiazTVe8pG8BiMyn92RVBJ4I25dozIom7amZQ6c=;
	b=X2YG53XCYyeEs4yQMkEvweXSJbkY089Au97HI+scAtcN9JZCKwPUy65015jvCiBfTGUYnS
	prfv4Ln2SJ49Di4QIrROcO3tlSi1F2y/A6smBrwHya6NQ/qEtTK+6eqQh+93ova+qRKZcS
	+YDEY0UBGRV3Kzj7Y66KLnqT34XsFKY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-m4LPJs62M5-ze3J-UiNnqg-1; Thu, 08 Oct 2026 08:08:21 -0400
X-MC-Unique: m4LPJs62M5-ze3J-UiNnqg-1
X-Mimecast-MFC-AGG-ID: m4LPJs62M5-ze3J-UiNnqg_1791461301
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-532f343a55bso85325861cf.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 05:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791461301; x=1792066101;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uI+XtiazTVe8pG8BiMyn92RVBJ4I25dozIom7amZQ6c=;
        b=BPPCQ0fplPqyiSosba3DYOMyXmmzFa7ykVXgDthtHPqm/TDC9iFnLqUai+EE/LfclY
         LAKOlU4Y/dpXGZDhXYN/Q3Jm8Gg0JxtcIckZjSBSMwu7YCp54ViY3hDfwB/XfktC1YaU
         IAd0YBD8lDaxpqNeEQBi8lrYKj4AASvs+mNqW93sL6wozVBgd5SM7/dXBro4TgIWEO20
         te88lVotTJp16b11dcUDJkPfcCGmGNJPTZ4GV/z0KBzHoX22CvcgPoWc4ihIfS4m7PIe
         80GOvjkK5JXXtCtn39dqG0PfddBBpiz3ORv+PE+GwsM1lhgESUCq1KHvV2th23RNG+QJ
         zZpg==
X-Forwarded-Encrypted: i=1; AKwUvBykaZZDwqBMVC5/ywxPxnkDRfSXBhJtTKX/pEMwutdSM1rZbQOEr24nDzEbA5jXRwXj/KxFO8ip9g==@kvack.org
X-Gm-Message-State: AFuF++m3M8ggckg3EoMdUCGkTni46bFmzaSv6mqm9cEoa/ihDI+irXF1
	S1wW/FsE0TFcE9makLnDPiyHRqH+t18UjedkbX+Nk7P5Udp+JDGXb33PBq8DgHzE9t9FG+XX5oq
	/LvTkujeimBbuomdMvAc7BWfkYIxITg35M36J8xt/7gK6vJUofgEE
X-Gm-Gg: AYBFou3eBIFQYzU7Y+u1UbnU70G3Gzsl0VAMmT968rg9Su0y55JWyZqtTwT/ZLcYmnu
	7M4AfoZfdHmkOTcSlTow7QBuDbj1iN+AiMAsouI1o2ihRMGrMu46gkBcX2favO5Gp+aUa1imwpR
	nt1sxohzXEynHnlRFyRN6waLTqSEOENNzM7h+xQIwlrziPdufuvF0t9oiU24slgxgHqpFg2qduz
	+O+rdPyYYctXXx1FJUEcbaLGXggTi5fnkdKV1aRTcsYSgC96aCBmR1Ah8YtJwLUG4yCTqTwWAL4
	VMQapt+0Xi5boMElqumG+V/BD2ojiUf7f/yQm946kp6tHaq4n5APhxZi+YZ5WmYrLjEsLr7M8i/
	7dVM=
X-Received: by 2002:a05:622a:508:b0:530:e1b1:eaeb with SMTP id d75a77b69052e-5357552d4bbmr98471471cf.21.1791461300675;
        Thu, 08 Oct 2026 05:08:20 -0700 (PDT)
X-Received: by 2002:a05:622a:508:b0:530:e1b1:eaeb with SMTP id d75a77b69052e-5357552d4bbmr98470711cf.21.1791461299930;
        Thu, 08 Oct 2026 05:08:19 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91996d20ae5sm44432586d6.27.2026.10.08.05.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 05:08:19 -0700 (PDT)
Message-ID: <4f7273ea-aec3-4a3e-8c83-927adfe6e17f@redhat.com>
Date: Thu, 8 Oct 2026 08:08:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
 <4db5fdee-4bca-43bf-8ded-2fd8808ac289@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <4db5fdee-4bca-43bf-8ded-2fd8808ac289@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PMfjzknvKZLJ4FYhxpGePzpjhDiIAQMLduGn4CYfDnM_1791461301
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 41F9D1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: s6zkepiexuziopsmno9zyxnxorsrp8n9
X-HE-Tag: 1791461305-680423
X-HE-Meta: U2FsdGVkX19a18Rkx/l1bWA2Wta7I/7vuiWRrPY6nyS5DhCYH7ywJuYlJh13KAsjVmnh2EhPd/CME7EVvOEVsXWTFeR17LNXUzPGVIFEQLhhdAHpXyauIMqjBR1YaLDKBBqzlJkwqRdTfZCV60GscEBSMzvx6SwkCQyuHdiBWOPXV0BJOiXwTR6dA0m2Iz7TFl3Vg0t4JjSgzt5xXdlR8Zrg/PyLUh+RkI8QjBzJzSD6pn8C1iSHnYYZ8r6LsdCf6wWbU1z0KTHpbkc/MI49VGL3TjESk9EH5FfvnzGmMEi0SBXO6f3gsY6DSLsCCf1gz0jOSNnHdAXobDzTadu64FAcA7GCCrf3aU3QK3BlIJhPwGZ0JGa4xF9aOzUrSK4UpxqqqJEMpp7TSzwbceT1YJDtz6UMLEELKhAoYYEdWLsS0dml6IR+Ywtz6rZ6UDEoECCPbiIbWcbL+bWOzZ3g8Zqvfjqx7GtjWkK1WIFTQOH9tfanCt5ygdTHLoOKzejk3RixzELbAlA694SCowiOAhNcQ6jBvxwJjW5DdSrC0NmJYU3d87V5XhSmSoMLk70R4eQSd1IIX2YV/tQd6hLc33fXxZhmyzJoRA6/U+Jl8OH8sReRxh7PleKzyYPoFC6+O3F4hD/tlxfSJaqQJR5ruLwvb3GCgS+XWGDOmmPHdCXIBgOxurGLaGPjzJqetq3vhapYpe3fAyVwRWQZnQkCpx2UGSdjWybSjEnaBLlXQndo5rfMYNO8dszzR7FzoPbehBJI4wxBp8qRQlJQOm0dT5ke+p44fR1ak0b0d9rk99JX1qPPO9tiZ3TYxRaIiLQUvSgOulQ448/uZSBtD8YUir7ICP3u6zfJT9bHKeKwlFhlG8MAwuczHZLqBUE9cWOMSeQUMHSLeCp/EiPiZLQLIw6M8sh4qhu2u4ApbSvEvS25xrvqHqTx7YPLKJwvf1D3RV35hfEgRNx2teGhBNG
 QVd4aZsG
 YucvO5Rioy0x7ZrcXCkDafGAFiNdOhoSy8SntkbyorlxFVGr58KGTrsCpcuNYVPOITlvcUN4ndcIcoyTjEmfaxXdIyCaBjSenvwVQy8YYw9cY5tVkI5ysLUksoGKcl6e8B9MiLZKWYYbv2fzEo1hdXARMhHergOCG50SrnlGneNeEN5pyHwxUbk5fRh3BsCQ3+jqtGf3oqkmoF7xWuLt8fcxTjw6nKG9DfThGgKVUb9X0INiriZW8afOQSkKEWvCb+fEBlzMaSpIsXbJ/ICnekkUUZqlU375LsN05oVNRI7dEm3HcWebvLnSVquaQvBQ5tjfKjrJhzEDEfubE+NEXeRA2UXRkRaNpqmMa6jcKOxWmnNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/7/26 10:07 PM, Baolin Wang wrote:
> 
> 
> On 9/18/26 9:45 AM, Luiz Capitulino wrote:
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
>>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>     considered
>>   - Filter out PMD and PUD orders from allowable orders when
>>     PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 25 ++++++++++++++++++++-----
>>   mm/shmem.c       | 14 +++++++++-----
>>   2 files changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index a06025b87e7c..a2d6de3ea988 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -189,6 +189,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       else
>>           supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves()) {
>> +        /*
>> +         * If the CPU does not support PMD leaves, assume for
>> +         * now that it does not support PUD leaves and disable
>> +         * both folio orders.
>> +         */
>> +        supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +    }
>> +
>>       orders &= supported_orders;
>>       if (!orders)
>>           return 0;
>> @@ -196,7 +205,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>       if (!vma->vm_mm)        /* vdso */
>>           return 0;
>> -    if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>> +    if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>           return 0;
>>       /* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -979,7 +988,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>        * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>>        * constant so we have to do this here.
>>        */
>> -    if (!anon_orders_configured)
>> +    if (!anon_orders_configured && pgtable_has_pmd_leaves())
>>           huge_anon_orders_inherit = BIT(PMD_ORDER);
>>       *hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>> @@ -1001,6 +1010,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>       }
>>       orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +    if (!pgtable_has_pmd_leaves()) {
>> +        /*
>> +         * If the CPU does not support PMD leaves, assume for
>> +         * now that it does not support PUD leaves and disable
>> +         * both folio orders.
>> +         */
>> +        orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +    }
>> +
>>       order = highest_order(orders);
>>       while (orders) {
>>           thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -1091,9 +1109,6 @@ static int __init hugepage_init(void)
>>       int err;
>>       struct kobject *hugepage_kobj;
>> -    if (!pgtable_has_pmd_leaves())
>> -        return -EINVAL;
>> -
>>       /*
>>        * hugepages can't be allocated by the buddy allocator
>>        */
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index bc2de3a7c1ea..8c0f7e3efeeb 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2046,11 +2046,14 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>       unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>>       unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>>       vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>> -    unsigned int global_orders;
>> +    unsigned int global_orders, disabled_orders = 0;
>> -    if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +    if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>           return 0;
>> +    if (!pgtable_has_pmd_leaves())
>> +        disabled_orders = BIT(PMD_ORDER);
>> +
>>       global_orders = shmem_huge_global_enabled(inode, index, write_end,
>>                             shmem_huge_force, vma, vm_flags);
>>       /*
>> @@ -2058,7 +2061,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>        * sysfs configs.
>>        */
>>       if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
>> -        return global_orders;
>> +        return global_orders & ~disabled_orders;
> 
> If you move the 'disabled_orders' filtering logic into shmem_huge_global_enabled(), as I mentioned in patch 8, then this change can be removed.
> 
>>       /*
>>        * Following the 'deny' semantics of the top level, force the huge
>> @@ -2072,7 +2075,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>        * means non-PMD sized THP can not override 'huge' mount option now.
>>        */
>>       if (shmem_huge == SHMEM_HUGE_FORCE)
>> -        return READ_ONCE(huge_shmem_orders_inherit);
>> +        return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
> 
> Since you've already disabled PMD-sized and PUD-sized orders for the 'shmem_enabled' interface in hugepage_init_sysfs(), this change can also be dropped.
> 
>>       /* Allow mTHP that will be fully within i_size. */
>>       mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
>> @@ -2083,6 +2086,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>       if (global_orders > 0)
>>           mask |= READ_ONCE(huge_shmem_orders_inherit);
>> +    mask &= ~disabled_orders;
> 
> Ditto.

Yes, I'll look into implementing your suggestions for the next version.

> 
>>       return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>>   }
> 


