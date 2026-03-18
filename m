Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF167FEDA17
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 01:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6306B00CA; Tue, 17 Mar 2026 21:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86F66B00CB; Tue, 17 Mar 2026 21:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D0B6B00CC; Tue, 17 Mar 2026 21:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88C5D6B00CA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:37:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AD098B89D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:37:22 +0000 (UTC)
X-FDA: 84557471124.28.7866317
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7832100003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:37:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NjtDm5Ti;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773797840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xoH794872OOyFq01xqhggvd+hqwGGLWmSAPwLLP/Fw=;
	b=6HKeHWGrb8YgFNlE4LdyOfjWeSDmboyboslAYstgY+PpFokfrA4hwFpYoys7Dz5jjdrLzD
	wVfPGxDjEchcvyCreqEjHaKifGUmJdVFKQZ8aRYNMtSRJJM0hECAvdFOCJ6N9EqxN7XvCQ
	/bYDiJwCCJmdQJIHhiV4hkcY2uy/FIw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NjtDm5Ti;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773797840; a=rsa-sha256;
	cv=none;
	b=rk5lZO6nsGCGrYoGsdYQrCqvqqw++zKD/o5x9MEUXRR0DcTPAIwef8ciW+ZZyYPrcUypaP
	JqLfXOojs7pptVrstAShucLQB4V66m9+cLl3IyfyIydFpbTKQcAh+eudpEFwXfXwrqfUoo
	jho6Y37rDH4EaN9atI4mgEy2ojdO4lA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773797835; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3xoH794872OOyFq01xqhggvd+hqwGGLWmSAPwLLP/Fw=;
	b=NjtDm5TiJtE07eVJGZWRHJUIQ/dvDon4obdRsxw0sPVyY6R8o/YzKffSjtwV+tmFHrBpqutkBYzRs7N2gFgynH/j8DE4WIXxxc5qaboPhe9RFxsLxNi7/+4jCvKKuOt0ctMRxHlasBBmPnwpen2RqxRE5VeFv9VBnq32U507jGs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X.CcSSy_1773797832;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.CcSSy_1773797832 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Mar 2026 09:37:14 +0800
Message-ID: <6bdc4b03-9631-4717-a3fa-2785a7930aba@linux.alibaba.com>
Date: Wed, 18 Mar 2026 09:37:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Barry Song <21cnbao@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <CAGsJ_4wZq7ZvMzMq513a89=VYs7gGkeVwSnAczxs_yYCHGFDQA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wZq7ZvMzMq513a89=VYs7gGkeVwSnAczxs_yYCHGFDQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7832100003
X-Stat-Signature: imdzz9zkszmnpu3c4m54cq5r83e3y4kh
X-Rspam-User: 
X-HE-Tag: 1773797838-906488
X-HE-Meta: U2FsdGVkX194Wn00HFd59xKri6Yy6nM1vLiCoOgPDwkbXKWla4zXRBp+/7uPI5G1vTldruM3n5/Ep9e3p+yCSdXJ3mHsgBw3hmkb9aDSismbFzZ+G1h3b40Jq0Vt9OwO65ETZtthEKI9FbU77qMimDqWjPtiS6YVtuQpglEoMSTRBJtk8H3gCD6vsvfBte/3Rp35u20wOkCOdvv4QzKBFHlTIG/z1DzehBZi6VgSOkwSksIs7hRX7gli/Afq0NXIGRN/uKoEVe5cJWgzkqh3Itrov+nrGtFcpwztQbtt868o9iu1GVYDHRumtE8t1LxbyDFMdsQRR4QzPLK+LmBUN33ipV9nEpUY+TtFjCKJItCR0ol8Etp6sadWyApjAuDw3HZPRJ+GVNu3vy86NeDNcbDx2CkCb6yvH/WPZnwlPFb9nNR5U9nJ4v4OCJW2j6egg4hjt60907XeoRresLBKHvCbFRha1TR5MWJp+xWRNzLcbXU5f9fn0sPpiRSg5/yN08WifWjA51dpkaTmCpqgZ7ILm7wBzfQzb55rtVfeXF1ki5c+GHUk58KaQZhvlASrI29mBMbrDaI832m7P5PiUwR66cGCaL+mNmkSCzPju1SLlWom7ccrkFZAkAUKAzgO5qSg3AALdaj2vacawDPvmWPqKODZfrc1+EaGfDdAPtkHpUVLfDGfAkGNtGSA4rYdxuRf93yHwuf4dUTCtnV89XwFotQICpRRTabBS/7wpVX4dN4h+XRKKVGxuXPTB7r0UA6kx7penT8+eLqy5cjHV58bvdcm9RprWY975YWMMq7bGgtTWf5W9pYMPqn3SlOvLBlm1NwIr5NF5gLcw6Lcg+UXsHiwcbvowmTclMRBiOeggjcX+HtQTfy8C0qTbZ34pbx0ZRksqPWIV/LGt/iup/ARC8VK1Qut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/17/26 3:30 PM, Barry Song wrote:
> On Mon, Mar 16, 2026 at 2:25 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 3/10/26 4:17 PM, David Hildenbrand (Arm) wrote:
>>> On 3/10/26 02:37, Baolin Wang wrote:
>>>>
>>>>
>>>> On 3/7/26 4:02 PM, Barry Song wrote:
>>>>> On Sat, Mar 7, 2026 at 10:22 AM Baolin Wang
>>>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Thanks.
>>>>>>
>>>>>>
>>>>>> Yes. In addition, this will involve many architectures’ implementations
>>>>>> and their differing TLB flush mechanisms, so it’s difficult to make a
>>>>>> reasonable per-architecture measurement. If any architecture has a more
>>>>>> efficient flush method, I’d prefer to implement an architecture‑specific
>>>>>> clear_flush_young_ptes().
>>>>>
>>>>> Right! Since TLBI is usually quite expensive, I wonder if a generic
>>>>> implementation for architectures lacking clear_flush_young_ptes()
>>>>> might benefit from something like the below (just a very rough idea):
>>>>>
>>>>> int clear_flush_young_ptes(struct vm_area_struct *vma,
>>>>>                    unsigned long addr, pte_t *ptep, unsigned int nr)
>>>>> {
>>>>>            unsigned long curr_addr = addr;
>>>>>            int young = 0;
>>>>>
>>>>>            while (nr--) {
>>>>>                    young |= ptep_test_and_clear_young(vma, curr_addr,
>>>>> ptep);
>>>>>                    ptep++;
>>>>>                    curr_addr += PAGE_SIZE;
>>>>>            }
>>>>>
>>>>>            if (young)
>>>>>                    flush_tlb_range(vma, addr, curr_addr);
>>>>>            return young;
>>>>> }
>>>>
>>>> I understand your point. I’m concerned that I can’t test this patch on
>>>> every architecture to validate the benefits. Anyway, let me try this on
>>>> my X86 machine first.
>>>
>>> In any case, please make that a follow-up patch :)
>>
>> Sure. However, after investigating RISC‑V and x86, I found that
>> ptep_clear_flush_young() does not flush the TLB on these architectures:
>>
>> int ptep_clear_flush_young(struct vm_area_struct *vma,
>>                             unsigned long address, pte_t *ptep)
>> {
>>          /*
>>           * On x86 CPUs, clearing the accessed bit without a TLB flush
>>           * doesn't cause data corruption. [ It could cause incorrect
>>           * page aging and the (mistaken) reclaim of hot pages, but the
>>           * chance of that should be relatively low. ]
>>           *
>>           * So as a performance optimization don't flush the TLB when
>>           * clearing the accessed bit, it will eventually be flushed by
>>           * a context switch or a VM operation anyway. [ In the rare
>>           * event of it not getting flushed for a long time the delay
>>           * shouldn't really matter because there's no real memory
>>           * pressure for swapout to react to. ]
>>           */
>>          return ptep_test_and_clear_young(vma, address, ptep);
>> }
>>
>> I don't have access to other architectures, so I think we can postpone
>> this optimization unless someone is interested in optimizing the TLB flush.
> 
> The comment is interesting. I think it likely applies to most
> architectures, including ARM64. The main reason ARM64 doesn’t use
> this approach is probably that it can issue tlbi_nosync and then
> rely on a final dsb to ensure all invalidations are completed—
> and tlbi_nosync itself is relatively cheap.

Actually, we both tried this a few years ago, but neither succeeded :).

My patch: https://lkml.org/lkml/2023/10/24/533

Your patch: 
https://lore.kernel.org/lkml/20220617070555.344368-1-21cnbao@gmail.com/

Now I’m more inclined toward your approach, to align with MGLRU. It’s 
time to restart the discussion on this patch? :)

