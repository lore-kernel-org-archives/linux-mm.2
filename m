Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E307CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 14:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6596B8E0007; Thu, 11 Sep 2025 10:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A478E0001; Thu, 11 Sep 2025 10:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520868E0007; Thu, 11 Sep 2025 10:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41FBE8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:42:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C48BBC02EE
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:42:41 +0000 (UTC)
X-FDA: 83877235722.25.ABCADB5
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id C67541C0015
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:42:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tmr60pWJ;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757601760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyNQL/XADmMA8QjSJmXvDYxgTnM2j84ik6oc2UrSO24=;
	b=gWS1uvmHRvvvSVzLjIY54ADC4qMJDtHohAz/Jwdn3hV3LbwWbmclWKI6qyO14zKh0Tjwgv
	261Tly4sqF/+k/oNleIIlV5PQ53A4+aIeCha+/6WKBTHI9K57sQNG7gO0nVyehrVG8WwMP
	VRzHm53jA2o+52W5dwYl1yhM5yj8xTE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tmr60pWJ;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757601760; a=rsa-sha256;
	cv=none;
	b=clRYvgwt2jE/NthUL3+Q1Da/Vf/5Qjll3JzwCSujiFhutLtFUAtIkRdhXkBuvRf6+irtt5
	IBRQjO3FXvxoxahX3olSdcXOx32mtAL0IB9szI7hKKky3VLdAnTOrjnGKBf6sNlgkZDxpY
	OLKAXzEpsESyTJI+WQRpAZF/sIbdjS4=
Message-ID: <5a2a4b59-9368-4185-bd08-74324eebacb3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757601757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyNQL/XADmMA8QjSJmXvDYxgTnM2j84ik6oc2UrSO24=;
	b=Tmr60pWJwACqzef1HJGGtGnSoV1/nJPnoK6NuDuZ6dCbpQYtgSh91GFlUn0zC1OB4sldeo
	pgYh606ZBE+ZDGVeZXsgjwUwrWNRvKmvfyMSPPPcC+3R9v9R8y+GWCDCzaXviM5Xfm05BR
	w4sa5d1NNASzGvGoWrlBd34pxB2ZKag=
Date: Thu, 11 Sep 2025 22:42:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
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
 <3b1c6388-812f-4702-bd71-33a6373a381a@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3b1c6388-812f-4702-bd71-33a6373a381a@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C67541C0015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ezydy853bjr6pzqympeq5sss9zycxso3
X-HE-Tag: 1757601759-95646
X-HE-Meta: U2FsdGVkX1/P4clLR5nY7jqxJJ4mvALMuIhntxG+hC3yGYZCuIatwJpclduz1h48vn3x5lp8A7kc3TyHZhP+dpoLUplDhtW7MKsTw7IwTiLOPB1D8wURqRCBqdzEYzQptaE3cIo5ILbEokkPUfmipXymFcV2Ikz2UxUzVq3BtypGvS8BsUBk/f7C+1Mb4LUjr9TwclRZMpGL+xLiqw2o7UW+kTov4NE67ibuJywDfA34XfKLNSDI7ACURYceq+RVL8vzYKKpIMF44MjlVkS3mpyQxqq87VDTTTvC25bOlIKQ1KE1AmuzBpshhlHQsStn09x6p+25vG03e/8P8Hk04BriHx/FHY0VRpBpOFbABJEz5Ps89Q2P3RvplXx53k6CviaNu8ARc4BOS1r1NclIAF68Iepgk51hux7OKGwE2+jdI7hG7yeLI0ROYU0L4+O3xz4c/1jvlXnEegWC3ZBUXa9GazVOO9Mzfp/u7otAzPBxmWBp8i/uEkGKkw7dxBd6vo4y9AMLSc56kzObvvyRD61Tic2Y2A2j1glDyZ2lhOxOersi7hf8MIyE2g1ePHPJ7BjF+gMVHjpq3xcJzAgJQOKgk8qVD89s9ApsvFp8TwtBOr/vcYB8mHFBOPZXdMbPk7wKnD6S1IxyyVc3teJ3KcxTb64NZhMhhxYr7i5UruLxhXyDeushRdcSdDDslEpFyo5gtfP8G7FLrX81hrpw3Oce2MYhwm6TzqPgLoMc21xHYh/8e+a6i/H+W2moBTt1ry5j9f0nGkWL7OmgUjhSUVk0UgfaKeS1r1iKLGcaO4CqDY9LDWTRKPvCKyH4R9F496rK/moLtyX1AH6DFQHEb1aXNcUnysdD1oJMDBlqs8lrRJtKW0Vy6CYNkY4MUl7HCwKXKZQu1XlOG1XhaTazpvj0otsp5ehPdBA62a7WQFaARQLsOET3z2GeyZpOk1cmqkG0rGQ/wb34+x++/zp
 AmHUSij+
 R60HGoqXeYSavFp9mgce5tuCecwKNfQ9MPM5PSRvNvkPRZj0TkmILVOsyYNHVB5truFgankHfu2l1I1JYGxHGLiQ9H8qyfKYSQEs8XHtis7o4b7zQcF/noqdNJ0W3NTuw5xfnJwzGDmPvtFZ4tZv4+AdjgjK5BDzEarP3i0QlJzYgtLFUtrMr2/m95zgEg1kPqidiNOeu02ywxOA16hJUPOfy5PT6qxZt+wy+KWYMKUzdU7nyS+KXI9Drvc4h5pVJxFiuiOOKUEuZAf4NaqXlX8XUrVmrM+pEVUWw14d/z7OCWja8COpb5J32c8ZdvD+pZD2mLuvrsApQmPEMeUuuG7vwQF3bjOolNDP18fGl/xEXwX2J1tSKELdpjHc6IZyU0yOcw1EYiOst3bf2VW8lk7PEWFMVV/ILWlsm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 22:02, Lorenzo Stoakes wrote:
> On Wed, Sep 10, 2025 at 08:42:37PM +0800, Lance Yang wrote:
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
> I think that adds confusion - as in how an order might be chosen from
> those. Also we have _received_ a bitmap of available orders - and the intent
> here is to select _which one we should use_.

Yep. Makes sense to me ;)

> 
> And this is an experimental feature, behind a flag explicitly labelled as
> experimental (and thus subject to change) so if we found we needed to change
> things in the future we can.

You're right, I didn't pay enough attention to the fact that this is
an experimental feature. So my suggestions were based on a lack of
context ...

> 
>>
>> Also, for future extensions, it might be a good idea to add a reserved
>> flags argument to the thp_order_fn_t signature.
> 
> We don't need to do anything like this, as we are behind an experimental flag
> and in no way guarantee that this will be used this way going forwards.
>>
>> For example thp_order_fn_t(..., unsigned long flags).
>>
>> This would give us aforward-compatible way to add new semantics later
>> without breaking the ABI and needing a v2. We could just require it to be
>> 0 for now.
> 
> There is no ABI.
> 
> I mean again to emphasise, this is an _experimental_ feature not to be relied
> upon in production.
> 
>>
>> Thanks for the great work!
>> Lance
> 
> Perhaps we need to put a 'EXPERIMENTAL_' prefix on the config flag too to really
> bring this home, as it's perhaps not all that clear :)

No need for a 'EXPERIMENTAL_' prefix, it was just me missing
the background. Appreciate you clarifying this!

Cheers,
Lance


