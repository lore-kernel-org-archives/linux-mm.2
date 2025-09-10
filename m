Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6C2CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5053A8E0003; Wed, 10 Sep 2025 09:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5C08E0001; Wed, 10 Sep 2025 09:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3F88E0003; Wed, 10 Sep 2025 09:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 21F0F8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:57:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5E8A5BB86
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:57:44 +0000 (UTC)
X-FDA: 83873493648.08.378D62E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id B316D2000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:57:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dhFFIoIi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757512663; a=rsa-sha256;
	cv=none;
	b=bpoEpMxLcWOyEYrbiedb/eLoTgCbcwHZtG1kTXn9HCk57d0bgbRyvBxQSFFuPYBU6xz4a7
	7cTCbNsNyu2YeeJJ56Ma9gzrjMCtptB8xIgLRP6Fezlq3O0m4hV8BwuwlxuhArlvfI7rtK
	uC7MuOISUTiptGeoZkNDmyloN88GS34=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dhFFIoIi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757512663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QC748CIWajxw/7iZYNCHx4/C+cp4Fd9J30JGsoguRxU=;
	b=oYCTgwYveSXRb7Ttn8vntPmB9PWLZ3ZlCKOnSWcEirHcYUIuI+YKVtI7RtmU2z9Db3d44O
	sWGOVrq8OBKot7ohQ7MH5iinbPIaLJt7v9p4mxR5az9YttxznrRET4BIMaes3Bca/kfSsI
	AjA1YTOnGfOm1VIB9dk2DuQFU5s4zNQ=
Message-ID: <ac633edf-4744-4215-b105-c168d3a734ce@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757512660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QC748CIWajxw/7iZYNCHx4/C+cp4Fd9J30JGsoguRxU=;
	b=dhFFIoIie+p/VEsPvypd9s5MRxg2Lb9DUmuYfQ3f2LNIuyyMPc8At2WhkWe6StPF30dk7u
	v6OjCUU+DwT0iZzkJbWGizycjetKlqt3SBsVAYC9YuPs1MoLzK+mAcKvJLbNN5dVynBoGm
	FRxJrDXHxeuBtNJXB9r2Fr/5sBnC5cM=
Date: Wed, 10 Sep 2025 21:56:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-3-laoar.shao@gmail.com>
 <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
 <CABzRoyYqGsABGVgXbH3Sts3yBsk7ED=BsKbcP3Skc-oWeFsN_w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CABzRoyYqGsABGVgXbH3Sts3yBsk7ED=BsKbcP3Skc-oWeFsN_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B316D2000C
X-Stat-Signature: y1s8r5xboeft3gcp3e7bjh9agbotx8f9
X-Rspam-User: 
X-HE-Tag: 1757512662-693064
X-HE-Meta: U2FsdGVkX1+qPfA8iFr688Z7RnJHPKo0DHhdLo3X6u4fqIk5OzKa6UFsi3RRHcXAztQQzSUO7+zjK0kHk0xeodAr879d7GhJ8VK2TGXMxdM69QXf+qAsOJ+g0/KTv3C9Ay7AnT/gktTSs26EQxf9NWur+6WmQiiNurrOCKBcf8lK1jfdqwft9E3tAmpyjeYClcc0dEk0G53tncNCqwZbiQRA1WcGF4O3PrUBseVI0rRzVGtUqsK9tssbVKSjhTq53mjQdOSFvN210b+dGHRo1r306YelyVuvI7SuspCgR4/EzHjC/UHHSX9Ev57ZbujdS8YJpZWrbp33Z9BbWe7XdKZifxzc/Y5+tHBM5tFCAv76kZtrND4Nm9fI5KanToklITPcSdU1VB8RmZaleHvDo1mp4b3vK0H+npLjsU+lJKfKjqmbB6kwoYHhMzJ1Ta9I/q0/D0SZXHjIN2/Sj0CC5DBzfMZaVPlNlfCZDHyf8jfitDdz+YkKDp36/0ZXFHPdDfgdCEtYd9vl7eepSjIZo8SJ0D4vlTs4XkSJgc3rvJuFiNbcftBnAOCNJQaJXnZiWyjbg3nB8CLFPAybGLSeSBqEtZvw8uiAPvoMexblr7pqEW6sICB364nQeKfdD3KdEbWUSxfWkLArBqmnMYtj99yMQE76T5nUf4332TIVURvPrtf8IvdC0oyxyTmh/HnxwmgzIMrnx0j2e5A8Ly3qiAqkkomh7tELVgrGbqTvFxVAqJXyB7Vx0auIjJ0QaiWWh2taADkJWUgkyL1LU4bFvNrPH+mIgF5rOCctITBTHkU9X5QePC+i6G8LlzlPrmXX1aSNcT6fgsMfmJYwqsLKkRT/G/IxaeVFa1TGAgqkVKXxA0a9eNDACwMz2w70UGsODEjAyUILPki3kcFUam62DXNT2yBhonm22f5CTWAgm+0pvzPsYdRoKhccoCRsv3WOF/+xoFRInsEVxTG6iOb
 3BtFHLnk
 ipG5QImlAGwOC/9ZFsfmScDai8Puvl1gymmnW7ljZC/soDSMZFQFaonAo65MQqs9soWEfKgdxO4SEAHnpQhdKUHv3lPyyruiCkLfQV4z7KtRk7JzbHxEqVVugbY/S6PZmTI/rGMwwvPwxShjkbINE3Ru5344xDbmTZnqAvFXw7l4ZLGVcXCjnxnXgNcCIg/qe7GX66MbRqxgIcr0hMzygKfrFiLbwllsMchpFo4RBjvankXBUzqSBg3+66H87HJ5Y1LOWjSGeKowkbPsJ48B5pVc5wmRm7PA3hycRK37OB/AVnBXerXy16m+1VTD0a9t9gwdgk9T40gdV8WnHjvb+6Cey4oIvROm6Y1LXRgdvEnDPgS2xRXTkurRiAQprRcLbYkhcJGtL72Zb6OF1rDK1cG29LCbOLorrKmgh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/10 20:54, Lance Yang wrote:
> On Wed, Sep 10, 2025 at 8:42 PM Lance Yang <lance.yang@linux.dev> wrote:
>>
>> Hey Yafang,
>>
>> On Wed, Sep 10, 2025 at 10:53 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>>>
>>> This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
>>> THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
>>> programs to influence THP order selection based on factors such as:
>>> - Workload identity
>>>    For example, workloads running in specific containers or cgroups.
>>> - Allocation context
>>>    Whether the allocation occurs during a page fault, khugepaged, swap or
>>>    other paths.
>>> - VMA's memory advice settings
>>>    MADV_HUGEPAGE or MADV_NOHUGEPAGE
>>> - Memory pressure
>>>    PSI system data or associated cgroup PSI metrics
>>>
>>> The kernel API of this new BPF hook is as follows,
>>>
>>> /**
>>>   * @thp_order_fn_t: Get the suggested THP orders from a BPF program for allocation
>>>   * @vma: vm_area_struct associated with the THP allocation
>>>   * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
>>>   *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE if
>>>   *            neither is set.
>>>   * @tva_type: TVA type for current @vma
>>>   * @orders: Bitmask of requested THP orders for this allocation
>>>   *          - PMD-mapped allocation if PMD_ORDER is set
>>>   *          - mTHP allocation otherwise
>>>   *
>>>   * Return: The suggested THP order from the BPF program for allocation. It will
>>>   *         not exceed the highest requested order in @orders. Return -1 to
>>>   *         indicate that the original requested @orders should remain unchanged.
>>>   */
>>> typedef int thp_order_fn_t(struct vm_area_struct *vma,
>>>                             enum bpf_thp_vma_type vma_type,
>>>                             enum tva_type tva_type,
>>>                             unsigned long orders);
>>>
>>> Only a single BPF program can be attached at any given time, though it can
>>> be dynamically updated to adjust the policy. The implementation supports
>>> anonymous THP, shmem THP, and mTHP, with future extensions planned for
>>> file-backed THP.
>>>
>>> This functionality is only active when system-wide THP is configured to
>>> madvise or always mode. It remains disabled in never mode. Additionally,
>>> if THP is explicitly disabled for a specific task via prctl(), this BPF
>>> functionality will also be unavailable for that task.
>>>
>>> This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to be
>>> enabled. Note that this capability is currently unstable and may undergo
>>> significant changes—including potential removal—in future kernel versions.
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>> ---
>> [...]
>>> diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
>>> new file mode 100644
>>> index 000000000000..525ee22ab598
>>> --- /dev/null
>>> +++ b/mm/huge_memory_bpf.c
>>> @@ -0,0 +1,243 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * BPF-based THP policy management
>>> + *
>>> + * Author: Yafang Shao <laoar.shao@gmail.com>
>>> + */
>>> +
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf.h>
>>> +#include <linux/huge_mm.h>
>>> +#include <linux/khugepaged.h>
>>> +
>>> +enum bpf_thp_vma_type {
>>> +       BPF_THP_VM_NONE = 0,
>>> +       BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
>>> +       BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
>>> +};
>>> +
>>> +/**
>>> + * @thp_order_fn_t: Get the suggested THP orders from a BPF program for allocation
>>> + * @vma: vm_area_struct associated with the THP allocation
>>> + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
>>> + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE if
>>> + *            neither is set.
>>> + * @tva_type: TVA type for current @vma
>>> + * @orders: Bitmask of requested THP orders for this allocation
>>> + *          - PMD-mapped allocation if PMD_ORDER is set
>>> + *          - mTHP allocation otherwise
>>> + *
>>> + * Return: The suggested THP order from the BPF program for allocation. It will
>>> + *         not exceed the highest requested order in @orders. Return -1 to
>>> + *         indicate that the original requested @orders should remain unchanged.
>>
>> A minor documentation nit: the comment says "Return -1 to indicate that the
>> original requested @orders should remain unchanged". It might be slightly
>> clearer to say "Return a negative value to fall back to the original
>> behavior". This would cover all error codes as well ;)
>>
>>> + */
>>> +typedef int thp_order_fn_t(struct vm_area_struct *vma,
>>> +                          enum bpf_thp_vma_type vma_type,
>>> +                          enum tva_type tva_type,
>>> +                          unsigned long orders);
>>
>> Sorry if I'm missing some context here since I haven't tracked the whole
>> series closely.
>>
>> Regarding the return value for thp_order_fn_t: right now it returns a
>> single int order. I was thinking, what if we let it return an unsigned
>> long bitmask of orders instead? This seems like it would be more flexible
>> down the road, especially if we get more mTHP sizes to choose from. It
>> would also make the API more consistent, as bpf_hook_thp_get_orders()
>> itself returns an unsigned long ;)
> 
> I just realized a flaw in my previous suggestion :(
> 
> Changing the return type of thp_order_fn_t to unsigned long for consistency
> and flexibility. However, I completely overlooked that this would prevent
> the BPF program from returning negative error codes ...
> 
> Thanks,
> Lance
> 
>>
>> Also, for future extensions, it might be a good idea to add a reserved
>> flags argument to the thp_order_fn_t signature.
>>
>> For example thp_order_fn_t(..., unsigned long flags).
>>
>> This would give us aforward-compatible way to add new semantics later
>> without breaking the ABI and needing a v2. We could just require it to be
>> 0 for now.
>>
>> Thanks for the great work!
>> Lance


Forgot to add:

Noticed that if the hook returns 0, bpf_hook_thp_get_orders() falls
back to 'orders', preventing us from dynamically disabling mTHP
allocations.

Honoring a return of 0 is critical for our use case, which is to
dynamically disable mTHP for low-priority containers when memory gets
low in mixed workloads.

And then re-enable it for them when memory is back above the low
watermark.

