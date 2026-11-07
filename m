Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9C3606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=s0wIDPw6
Received: by kanga.kvack.org (Postfix)
	id 7CA426B05B5; Fri,  6 Nov 2026 21:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77AF96B05B6; Fri,  6 Nov 2026 21:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669786B05B9; Fri,  6 Nov 2026 21:49:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDC66B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:49:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C81C71402A1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:49:05 +0000 (UTC)
X-FDA: 85406791050.23.A691194
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id D37901C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:49:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s0wIDPw6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794019744;
	b=2uf1YyktFzi/QVKNo5MHmqfjuw9aloOUzjqittqmWPHyGEq0ERa6HJoaJuFSuzj6b7w5Ty
	BbIh8q7dedv0f+pHKW9eN3z489oQpXIwVWLfQ0Trg5ltGjHhxV0hu3Bih+d+rUXNCTDL0o
	WQUIg6cQ6WMIPAiY9DADwuRX/E7D6+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794019744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2ehoWyNFIHWoL0rk22oGF6YUNoTHO9lXNQV3gq5XAw=;
	b=c4l18lOo2mSiaJSTqZjQdim7jgZznCWwnQzG6llbI6HYqLyn9gSuG9ldh76zRNTaKQM3jC
	VCHl+95H6u/E3SsmCvlmuwV0hD7pni1E1gxPjVybLE2ajtiQy4qSNFpKFlJ50kOXbMlY0F
	OrVVbgfRAaho5+VizqmnqgfrIeuorzA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s0wIDPw6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=V2ehoWyNFIHWoL0rk22oGF6YUNoTHO9lXNQV3gq5XAw=;
	b=s0wIDPw6+NyU33w1CyCBkI8Y8vDmSApq0sauZ/wEZxbcU4l7lsdb3uSJU+v1v4l5cUTFcM458
	4qc3r5URfrkrhbhJ3s2b9R+f4yAZjd3r1veaUc0rYNmNhBAY0eHS6XCaccSQWKhxC4KvxjPjNwK
	hn/kBO/rUBSPTZNUNXqFJTw=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jM0pr45pgzcZxr;
	Sat,  7 Nov 2026 10:48:20 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 54E9440575;
	Sat,  7 Nov 2026 10:48:52 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 7 Nov 2026 10:48:51 +0800
Message-ID: <7e9d20b9-ed6c-4f65-a332-9936722e9ec0@huawei.com>
Date: Sat, 7 Nov 2026 10:48:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
CC: <akpm@linux-foundation.org>, <david@kernel.org>,
	<chengming.zhou@linux.dev>, <liam@infradead.org>, <ljs@kernel.org>,
	<vbabka@kernel.org>, <jannh@google.com>, <pfalcato@suse.de>,
	<kees@kernel.org>, <ziy@nvidia.com>, <gourry@gourry.net>,
	<anthony.yznaga@oracle.com>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
 <au2PwSAxOU3W9pwF@dgvxl46587.localhost.localdomain>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <au2PwSAxOU3W9pwF@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: D37901C0005
X-Stat-Signature: 9o8kod5ni6oimuiob3ggcgmeacbg55sj
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794019740-286620
X-HE-Meta: U2FsdGVkX18fjXkiUVJECOF/v6Y+YuHCOnRFmeFaMJPDUizer2ONpo6+PWtTxt/jeSWR8p8owUgYB020r3hC6WnxcZ44R0yueaOf5S7d7O/z5Q6f7l6YziGcPm5DyzyhtNxgXP6+U28FcNhjVZtHwdSEVLb1iAQNgZCIgBiPYHrcl+iqOuf0SPlnZQ+5MUKR3JWJXHif4xA59u/9lETuNTu85jFs8P/JGmmWet33V2UYTy0b+l3Gg1/ihNYZEaZVO4dVIT1o/oQBmPlOifbmSH/qhW3CQpHOH0pbcDmUdcrEfz+raxBdjl85mwMa0d5UjEzIN4Ye+oHv/+8UipQklCAHdvK0eRKJujD27aN3OFoh7IlgwZqvKrIAM4yh7/hpNuLDCc0tIsJe1Fmb12kA72y+DdbxFJBYrLt1yHI2PRsIEP+CgeL2pd7S0A87XtKp5LldgY4DxUTNomDZWGi8BsYdRn/8H4VCo+vRa+kbcrtTvckS/3YyLBoVVHiSeBboyaORmLEVOCDguUy9ADRCaK+sB6mSMt7mDvVS4q9CNFNY7Q2wKphSR8yOUA7RUHFnVh41+8fsPFrVQARCAllJlofiA1sHrzgs2NlJPnfNpdOuGiHmq0NJ4+uWgI6HPJQAbkDzSDBi2Nopr03Uc8kT4GJTFcwq1H1Pg/T/vbUfABiJpwYGYI0LVUJPBLdnar4cSXMhWDOxWsGUcD1+dti13G4h+wZtmcrm0MnSq+wn8vmKY0wu7HuTLbz+inkbamvxjMQ0LGfaesDnaPRAWcaT8NJsAEMQ7ibU2vKjON6AfpTvn9VW3Rh+dOK99+7/Y8+HLO0yRumbTGYU5DKcpiDEXmkazSH3ZN0WaD8g4HoBSbEaXIfUrc9AgbkuyV+/96nXdyM+B79r+0EOXpBC+cfoux6go08iIZmWC9ObROnOrUi2VmEvS/M4z16H1B1AIWpMepthThs0H1K7AkK2+Np
 Fgo5SNBa
 PV6mXlWulAxMWzv6jtQHTlPZM08civDECdRU4dG4cVUmL3UrNWwjZLjf1g78c6aMGXUS1W8u+t2fKPyg8T1kDBFRQFcf6n5BRz9T6V8cZYK/QPqGub5yOLe9+Ft9heQSrGS0ARAL/82cykOtEgoxKBuPWH21g5uEUQizA2MQKlWZCg+rxCcmjGTiEfbRXEYBjOgB/kBZvHsYu+fhcy6aK0BJduoxKWY0KYcJuhiylURto9JPgvhJ/6wXqsWyEg57+TbmdFOmkS6FIVKaFuhx5GzkmY9L5QxK9qxkPBY25fO4T5AQ9BX1p7bC8X7R0ywkFx8GSYpQ1Y9SJKg016DXLRh24iF9yz7EieMvDBAiusflDZEoDsGplJicTn0zVUusWdmyOZQ1GLe69JwAtrA/RgmuAf5qSrkEI8efWpG4q5whTdKXAHY10nBut11IkqvIkuZoy+C2uRkc0Yytji4N3uXH5MfezR7yxjuFo3vksg4Tv8wY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/11/6 16:28, Xu Xin (vivo) 写道:
> On Fri, Nov 06, 2026 at 09:39:06AM +0800, Jinjiang Tu wrote:
>> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
>> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
>> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
>> again when the mm is ksmd's current scan cursor, leading to deadlock.
>>
>> The early registration is no longer needed after commit 590c03ca6a3f
>> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()

Thanks for review.

> We can go into more detail. like:
> "The early registration ksm_execve() during the exec() is no longer required,
> since when the process subsequently carries out the actual memory-allocation
> operations, such as brk() or mmap(), ksm_vma_flags is invoked to re-check
> MMF_VM_MERGE_ANY and register the mm with KSM."

Will update it.

>
>> calls __ksm_enter() when the first mergeable VMA is created. Remove
>> ksm_execve() and its stubs.
>>
>> Tested with ksm_functional_tests, all tests pass.
> If possible, can you provide a reproducible testcase in
> tools/testing/selftests/mm/ksm_functional_tests.c in V2 ?

ksm_functional_tests.c has tested KSM setting is inherited
after fork/exec.

Or do you mean reproduce the deadlock? It only reproduce
when insert_vm_struct() fails to allocate memory, it's
almost impossible to trigger in practice.

>
> Generally Looks good to me, thanks!
>
> Acked-by: Xu Xin (vivo) <xu.xin@linux.dev>
>
> Thanks!
>
>> Fixes: 3a9e567ca45f ("mm/ksm: fix ksm exec support for prctl")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   include/linux/ksm.h               | 13 -------------
>>   mm/ksm.c                          | 16 +++++++++-------
>>   mm/vma_exec.c                     | 10 ----------
>>   tools/testing/vma/include/stubs.h |  5 -----
>>   4 files changed, 9 insertions(+), 35 deletions(-)
>>
>> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
>> index d39d0d5483a2..5e228935cede 100644
>> --- a/include/linux/ksm.h
>> +++ b/include/linux/ksm.h
>> @@ -66,14 +66,6 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>>   	}
>>   }
>>   
>> -static inline int ksm_execve(struct mm_struct *mm)
>> -{
>> -	if (mm_flags_test(MMF_VM_MERGE_ANY, mm))
>> -		return __ksm_enter(mm);
>> -
>> -	return 0;
>> -}
>> -
>>   static inline void ksm_exit(struct mm_struct *mm)
>>   {
>>   	if (mm_flags_test(MMF_VM_MERGEABLE, mm))
>> @@ -118,11 +110,6 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>>   {
>>   }
>>   
>> -static inline int ksm_execve(struct mm_struct *mm)
>> -{
>> -	return 0;
>> -}
>> -
>>   static inline void ksm_exit(struct mm_struct *mm)
>>   {
>>   }
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index dbfb8f98b189..2e0f894208d8 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -2777,11 +2777,11 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>>   
>>   		mm_slot_free(mm_slot_cache, mm_slot);
>>   		/*
>> -		 * Only clear MMF_VM_MERGEABLE. We must not clear
>> -		 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
>> -		 * perhaps their mm_struct has just been added to ksm_mm_slot
>> -		 * list, and its process has not yet officially started running
>> -		 * or has not yet performed mmap/brk to allocate anonymous VMAS.
>> +		 * Only clear MMF_VM_MERGEABLE. MMF_VM_MERGE_ANY is the
>> +		 * per-process setting inherited across exec, so it must
>> +		 * stay set until userspace disables it with
>> +		 * prctl(PR_SET_MEMORY_MERGE, 0). A later mergeable VMA
>> +		 * re-registers the mm through ksm_vma_flags().
>>   		 */
>>   		mm_flags_clear(MMF_VM_MERGEABLE, mm);
>>   		mmap_read_unlock(mm);
>> @@ -2909,8 +2909,10 @@ vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
>>   		vma_flags_set(&vma_flags, VMA_MERGEABLE_BIT);
>>   		/*
>>   		 * Generally, the flags here always include MMF_VM_MERGEABLE.
>> -		 * However, in rare cases, this flag may be cleared by ksmd who
>> -		 * scans a cycle without finding any mergeable vma.
>> +		 * However, a newly execed process has not been added to
>> +		 * ksm_mm_slot. The first mergeable VMA registers the mm
>> +		 * with ksmd here. ksmd can also clear it after a full scan
>> +		 * cycle without finding any mergeable VMA.
>>   		 */
>>   		if (unlikely(!mm_flags_test(MMF_VM_MERGEABLE, mm)))
>>   			__ksm_enter(mm);
>> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
>> index 586c52155942..2c644e18b55d 100644
>> --- a/mm/vma_exec.c
>> +++ b/mm/vma_exec.c
>> @@ -128,14 +128,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
>>   		goto err_free;
>>   	}
>>   
>> -	/*
>> -	 * Need to be called with mmap write lock
>> -	 * held, to avoid race with ksmd.
>> -	 */
>> -	err = ksm_execve(mm);
>> -	if (err)
>> -		goto err_ksm;
>> -
>>   	vma_flags_set_mask(&flags, VMA_STACK_FLAGS);
>>   	vma_set_anonymous(vma);
>>   
>> @@ -163,8 +155,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
>>   	return 0;
>>   
>>   err:
>> -	ksm_exit(mm);
>> -err_ksm:
>>   	mmap_write_unlock(mm);
>>   err_free:
>>   	*vmap = NULL;
>> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
>> index f786a585caf0..9ab4e524f78e 100644
>> --- a/tools/testing/vma/include/stubs.h
>> +++ b/tools/testing/vma/include/stubs.h
>> @@ -55,11 +55,6 @@ static inline void free_pgd_range(struct mmu_gather *tlb,
>>   {
>>   }
>>   
>> -static inline int ksm_execve(struct mm_struct *mm)
>> -{
>> -	return 0;
>> -}
>> -
>>   static inline void ksm_exit(struct mm_struct *mm)
>>   {
>>   }
>> -- 
>> 2.54.0
>>

