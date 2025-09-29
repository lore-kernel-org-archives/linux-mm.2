Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BF5CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B528E0003; Mon, 29 Sep 2025 09:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923AC8E0002; Mon, 29 Sep 2025 09:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8128D8E0003; Mon, 29 Sep 2025 09:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A47D8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:22:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4D0958AE7
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:22:50 +0000 (UTC)
X-FDA: 83942352900.03.67797EC
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 92A98C0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:22:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nofgTvVc;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759152169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEY4Wq5zRiJY8ZDmsjRBwwv7BQUDjoacSGQVy+nSiw8=;
	b=ZyUaTB0R1IkK7SlKDRyE69uaWRHiAPAILFF39AO4peR9/riyoOW29z6MPVEQ1pqsY0JD75
	PjOPHgXviDuaaYIcbHTJqkVeINgyWoDPemYhezqIg/65qOOqBWWvkfj5CakGB9BFep+ajr
	njZMlsjuPtHIAMPru++/7fkpdfG//5s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nofgTvVc;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759152169; a=rsa-sha256;
	cv=none;
	b=zNVM0/PSn/4LdgH5jOW782PwedDK8TBkkbjrsjdpWWs37AwSDifzR9q8BBQytobyiA//Tl
	ewIgKy/5PNbwhYN2PORhdPuNFuut9FMA8Sr8dhlwZSfbGiO/FQq6Yp67vWqeYtCtbP4uvy
	XHL9OBsBGx17mafEK8ZL0K6V/UktXVk=
Message-ID: <0701c9d9-b9b3-4313-8783-8e6d1dbec94d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759152165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gEY4Wq5zRiJY8ZDmsjRBwwv7BQUDjoacSGQVy+nSiw8=;
	b=nofgTvVcT7NTFQk/LoeYAL1QMMD+NwAgSMS5++Z3v51RGaY0qB/4sNR1XmpkccV1gutI6R
	FN4D8JDH3/YFp7o+/xwfMvq9ZK+7IugxZZGwSgCbVwFWu2CZ0heC7OFSz/U5B7PLrjj3eH
	anK6qqN9M0/hCNWp+lVtGY1zP+HCSHY=
Date: Mon, 29 Sep 2025 21:22:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <20250928044855.76359-1-lance.yang@linux.dev>
 <b19b4880-169f-4946-8c50-e82f699bb93b@redhat.com>
 <900d0314-8e9a-4779-a058-9bb3cc8840b8@linux.dev>
 <1f66374a-a901-49e7-95c8-96b1e5a5f22d@linux.dev>
 <69b463e5-9854-496d-b461-4bf65e82bc0a@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <69b463e5-9854-496d-b461-4bf65e82bc0a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 92A98C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qfps6fidnuks7611ab6fmx97q4agn8tb
X-HE-Tag: 1759152168-160206
X-HE-Meta: U2FsdGVkX1/1BokDc16briYDSaKgux6l3TPEe4DsD8NG6DYgBzdxaotH3ohnsVSYRS4ACgxoEbkkxt9Mo9RjV8G5rlHgB0RyoTsTm2Khgl/q2YZCKUCwTrNGNNh5PR4WhuTw48hSPvUorw1jbEj1FK53p9Gwly1BUfS4u7qoo0XhnzQazrZ427P6FNm3ekLRvPnDIPVgJury9GeNR4ZJsyjyFUUSMX2NyGaMGru6RByT4DDhaureZn3ER/GmkXs080pGfaT7F3S54J2KRv66z7+wmJ3bKJtEw/h4ZX+AWUPw3hD/jJ5TXtGIHa0QpQ00PrHSDV5R5MWjWagAWWuz5Eh7edshflJ0GbbL+lZxTHrCYwl4PfspOeN7FBeqXb0y5p/+4dY7mTRWZywkADPf2FxvIfqtMbAeLmXzDv2yk9hTFhPyafdQ9xd3jFnWU1BNrsDi2VwtN0MUHU3Q+4QV8NWr+lNUf9Xfakbmeb3KhYzNl4R9jvZErQZptmGmc2Ais2Zg7FuvHEARAJidyFPl7ZNlHucK3mdUYkYpQHiZlhhTld2FVUwsvxQRh+AGPTkb4ssVUabge696TIWotSgeoWZAJtew78wlZMGZdaVNnWbQ88B82tcphsk6Q+AaVfC/wOOS11pZLU9y+tZ8lDUF0UKo4U7OmvLExilcjdOHcgANn9hEkmKOf4ZNfnMv6KQ9cjeiFxJB8mS3Zn2DGRFg508gzfCHUtK8IDTiB6vu43Iv5BKTtljnc4NRfQt80/T9+9feBOMAMwQ8q532yXqW7tckua+dfyUJh+08zf/DgtceAzvJE9kO19s6dVSRf2vBroIe9OCY/rSFWbVgMuLa/B79WUwOjTyU7z9R0ZFNCWWL4qIuF1tlwLY+9cZ8PJ4YekXBCpW3u+pdhfdUyLNLDcdNwA93i3479zHK+AF+bkI2hyi7Ckl4W3js7eAAk18dLFAP4Puik6J+XZnr5ZO
 FwW2JGc/
 VI1qb2h2HWGhoWXB1TmtHEUM0z+l0qU6bHqF4avGsbc7ZTUlV0YEKJuDdzcyY8vTCUrxccc2NFwMGa79StmBDzyWg7Qv3p3ITUPykabFvxLVYyt9m5P+TglplSElqHo0ltRsj583szi2Dg2illNii5Y4tbBBdq87SUIeXnWOVfyGF8dqQQ+mr1Bl0Lt4iCYopVkZWH8J6BUcQA5tTScmSNw+yPuTygereOq50gTOpuZHIcN2/txiINn9y3Sb7b8iFAybjsFFLByDclnEpqEAbatUmhaIl2MZxvTT/DvwcOMkmcZ/6IopOuXsuXA9CZGZE1XC7mdJjCL2PcW9RtosCwXwpMOeSaXdEEaTB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/29 20:08, David Hildenbrand wrote:
> On 29.09.25 13:29, Lance Yang wrote:
>>
>>
>> On 2025/9/29 18:29, Lance Yang wrote:
>>>
>>>
>>> On 2025/9/29 15:25, David Hildenbrand wrote:
>>>> On 28.09.25 06:48, Lance Yang wrote:
>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>
>>>>> When splitting an mTHP and replacing a zero-filled subpage with the
>>>>> shared
>>>>> zeropage, try_to_map_unused_to_zeropage() currently drops the soft- 
>>>>> dirty
>>>>> bit.
>>>>>
>>>>> For userspace tools like CRIU, which rely on the soft-dirty mechanism
>>>>> for
>>>>> incremental snapshots, losing this bit means modified pages are 
>>>>> missed,
>>>>> leading to inconsistent memory state after restore.
>>>>>
>>>>> Preserve the soft-dirty bit from the old PTE when creating the 
>>>>> zeropage
>>>>> mapping to ensure modified pages are correctly tracked.
>>>>>
>>>>> Cc: <stable@vger.kernel.org>
>>>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage
>>>>> when splitting isolated thp")
>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>> ---
>>>>>    mm/migrate.c | 4 ++++
>>>>>    1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>> index ce83c2c3c287..bf364ba07a3f 100644
>>>>> --- a/mm/migrate.c
>>>>> +++ b/mm/migrate.c
>>>>> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct
>>>>> page_vma_mapped_walk *pvmw,
>>>>>        newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>>>>                        pvmw->vma->vm_page_prot));
>>>>> +
>>>>> +    if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
>>>>> +        newpte = pte_mksoft_dirty(newpte);
>>>>> +
>>>>>        set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>>>>        dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>>>>
>>>> It's interesting that there isn't a single occurrence of the stof-
>>>> dirty flag in khugepaged code. I guess it all works because we do the
>>>>
>>>>       _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>>>>
>>>> and the pmd_mkdirty() will imply marking it soft-dirty.
>>>>
>>>> Now to the problem at hand: I don't think this is particularly
>>>> problematic in the common case: if the page is zero, it likely was
>>>> never written to (that's what the unerused shrinker is targeted at),
>>>> so the soft-dirty setting on the PMD is actually just an over-
>>>> indication for this page.
>>>
>>> Cool. Thanks for the insight! Good to know that ;)
>>>
>>>>
>>>> For example, when we just install the shared zeropage directly in
>>>> do_anonymous_page(), we obviously also don't set it dirty/soft-dirty.
>>>>
>>>> Now, one could argue that if the content was changed from non-zero to
>>>> zero, it ould actually be soft-dirty.
>>>
>>> Exactly. A false negative could be a problem for the userspace tools, 
>>> IMO.
>>>
>>>>
>>>> Long-story short: I don't think this matters much in practice, but
>>>> it's an easy fix.
>>>>
>>>> As said by dev, please avoid double ptep_get() if possible.
>>>
>>> Sure, will do. I'll refactor it in the next version.
>>>
>>>>
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>
>>> Thanks!
>>>
>>>>
>>>>
>>>> @Lance, can you double-check that the uffd-wp bit is handled
>>>> correctly? I strongly assume we lose that as well here.
>>
>> Yes, the uffd-wp bit was indeed being dropped, but ...
>>
>> The shared zeropage is read-only, which triggers a fault. IIUC,
>> The kernel then falls back to checking the VM_UFFD_WP flag on
>> the VMA and correctly generates a uffd-wp event, masking the
>> fact that the uffd-wp bit on the PTE was lost.
> 
> That's not how VM_UFFD_WP works :)

My bad! Please accept my apologies for the earlier confusion :(

I messed up my test environment (forgot to enable mTHP), which
led me to a completely wrong conclusion...

You're spot on. With mTHP enabled, the WP fault was not caught
on the shared zeropage after it replaced a zero-filled subpage
during an mTHP split.

This is because do_wp_page() requires userfaultfd_pte_wp() to
be true, which in turn needs both userfaultfd_wp(vma) and
pte_uffd_wp(pte).

static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
				      pte_t pte)
{
	return userfaultfd_wp(vma) && pte_uffd_wp(pte);
}

userfaultfd_pte_wp() fails as we lose the uffd-wp bit on the PTE ...

Please correct me if I missed something important!

