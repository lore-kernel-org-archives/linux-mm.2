Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5681CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 11:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE808E0029; Mon, 29 Sep 2025 07:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F378E0002; Mon, 29 Sep 2025 07:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBF98E0029; Mon, 29 Sep 2025 07:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB7FF8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:30:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9422C1402EC
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:30:10 +0000 (UTC)
X-FDA: 83942068980.11.B316B75
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5B29D180003
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:30:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VspuXG7W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759145408; a=rsa-sha256;
	cv=none;
	b=pvippCj9ll7ZxSLS/J3MYGsQnwz80ovkzHbQN5WaTP16NkIZm3rqnJVklM50DrYWntekKZ
	7embn3YjIfg0lUTKb30KG3Y1kL1pDzZ5FWC2NJo2WUKkgb3j6HIaz/Bx/HRjiqoHYQjrNZ
	5MmhzwOKTMkt0SBahK6A5KzoYeO47Dw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VspuXG7W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759145408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6doKxVQhLyaOgKfPSYUAjAC40Y3b75Sc0EmJyThepY=;
	b=agVkJVUD4FcIHFwF4TlYeR8/q2K9/kFoVLVftJJYSEDxNGlJtruSpC5VDct1GDBhtd7j2t
	5LQcgJiufjI3aPoZNB8Lu6upbtbWHUrpYDfIu8n3OBUCJrIZcbUk/D05U1v4O0KVTkA3sk
	EKtcU49Rm5tOV8FuN75p/T6xPQJbjGQ=
Message-ID: <1f66374a-a901-49e7-95c8-96b1e5a5f22d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759145405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p6doKxVQhLyaOgKfPSYUAjAC40Y3b75Sc0EmJyThepY=;
	b=VspuXG7WCTzVKmR7dczYvue+Qlr+fKoTDyt/XzVx1ofqqz4QGx7R83d8r70CwfFWVOBMHl
	bS+sGab7yy4hmZ7+JyOTildW6sPMTp0VdAT+tbawIuqKNj4VExoCO4o33cPTjNpnNWQvIk
	rSXGmENBlSnQgKQnP4qfubfDjYKnau4=
Date: Mon, 29 Sep 2025 19:29:45 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
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
Content-Language: en-US
In-Reply-To: <900d0314-8e9a-4779-a058-9bb3cc8840b8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B29D180003
X-Stat-Signature: zj548xjcdwz3frqjbs78aoukahhak3iu
X-Rspam-User: 
X-HE-Tag: 1759145408-922388
X-HE-Meta: U2FsdGVkX1/nVsOP3st8WWVjxGno0Y+d4DkTix0TwiGQXYf3Wd6KTDLnVvvFOPwT9JsTcJP/po40FCGU88GoW5joOUy6AqZQ11SNOBLYTbl5UMc3f4G4tnPgduA7OjnnBkRUetPvm0i3Rp+5jL1g+6klpcyp2Z2vw5BcDa5davINHcWn9UpuA2L2VAG3lfpm2tH9KckBRWxeMsBBoOAD7Z8dNKFAf0wNYRphmKBUAM37CqH5cYfwr1M7ssihVtaO6idBZl5pEnmOoeNglEsgKR9U8bafbbGA13nWdKmfq7MC5PkLxAsnSwTy9SiOmuVHZbTVsUs6rt/AQBeM3xgdWskQ/5QWJEAYLUUaznP5e0PzS2+dqb9hA6RFoNVJVjzBQ/VhtFGvTzUxCRpEtzUbEt+yM3TbThSPH3jGHSpIjr7lvXcawcwzExRzIf3r60CvMUEE3dQlLu02m2Pyed0BBmpZBn113wRaZYwj/Piwm1VjNEaJ1npZsrxtmpeFrB8+gqNmy3ByBUi46aMdz9ISEHSS/c/KskR6uNTpmuqIK9XFYKyXzevYryGowIhp4rMXPRfokIAFg24tyyxBRoGnkngedyJydAtUL6a2nkAGJ2whkikvy9REQM/SNRa0bsXukoj+CWYyXcNPcH0RaxP0KNKUjc7c2q8CTgUrLITwy8xCPpVBv6JseBNxQIGrrn2skEhdswpLqHZcy7PLtSVpbR/u9c4NzsA9hk0T+bL+Nf6hiRfd4ciHIl3kBmqCKlD30ulLqmnjybOHpSlGI+Y7Hsc4w6FV9SpcR2UGlLeqxkONNnQU/7ngBwhDincFFlpJ9N1m2TJDaUNjA3AvvftVPx6W9QPOTgLuo21Xu55EKQcpZZIPAyb2k0x+ItlX/hwjZfLA65DXt23qghoYlhXOcG+vYtANIB/BVjFKSLxtAr3TaQhLz7cGrrQumshsU/nMVedRxdKEDL1gCH8BHDR
 moEf5l7Y
 t6ClSnkb3BpX+oKqUv/GQbdn9xEucRXumhNecMxaSVI5SwrEJNqkWP+upZrB1+rovYTPEMM5KwcP75kItakfHbQ8ELC+dHz0cyYBBvx+JG/lAt0hWOFO2OAhl8c24j/vfhPmurYZwW5q3sZi6leCShv7sSsvhXN/NspvxLtvy7Ycn6aBYsSjQMqlsrMt/UFmCztgd+mhnMCQ0oSP3VSknm8aynAnMtYJCpdgtQDB9679KHEK4oL/DsZf6a9MsojQcyB5afFm8VjjZaRKgwYr/wCsFi+78hJ0BDkKjkdXh+fkxZbw80wq3GC/bc0DxE6F+M9608xyCBbSZAhe6mm7A3OmB1tAiKhHDR8BF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/29 18:29, Lance Yang wrote:
> 
> 
> On 2025/9/29 15:25, David Hildenbrand wrote:
>> On 28.09.25 06:48, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When splitting an mTHP and replacing a zero-filled subpage with the 
>>> shared
>>> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
>>> bit.
>>>
>>> For userspace tools like CRIU, which rely on the soft-dirty mechanism 
>>> for
>>> incremental snapshots, losing this bit means modified pages are missed,
>>> leading to inconsistent memory state after restore.
>>>
>>> Preserve the soft-dirty bit from the old PTE when creating the zeropage
>>> mapping to ensure modified pages are correctly tracked.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>>> when splitting isolated thp")
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>   mm/migrate.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index ce83c2c3c287..bf364ba07a3f 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct 
>>> page_vma_mapped_walk *pvmw,
>>>       newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>>                       pvmw->vma->vm_page_prot));
>>> +
>>> +    if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
>>> +        newpte = pte_mksoft_dirty(newpte);
>>> +
>>>       set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>>       dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>>
>> It's interesting that there isn't a single occurrence of the stof- 
>> dirty flag in khugepaged code. I guess it all works because we do the
>>
>>      _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>>
>> and the pmd_mkdirty() will imply marking it soft-dirty.
>>
>> Now to the problem at hand: I don't think this is particularly 
>> problematic in the common case: if the page is zero, it likely was 
>> never written to (that's what the unerused shrinker is targeted at), 
>> so the soft-dirty setting on the PMD is actually just an over- 
>> indication for this page.
> 
> Cool. Thanks for the insight! Good to know that ;)
> 
>>
>> For example, when we just install the shared zeropage directly in 
>> do_anonymous_page(), we obviously also don't set it dirty/soft-dirty.
>>
>> Now, one could argue that if the content was changed from non-zero to 
>> zero, it ould actually be soft-dirty.
> 
> Exactly. A false negative could be a problem for the userspace tools, IMO.
> 
>>
>> Long-story short: I don't think this matters much in practice, but 
>> it's an easy fix.
>>
>> As said by dev, please avoid double ptep_get() if possible.
> 
> Sure, will do. I'll refactor it in the next version.
> 
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks!
> 
>>
>>
>> @Lance, can you double-check that the uffd-wp bit is handled 
>> correctly? I strongly assume we lose that as well here.

Yes, the uffd-wp bit was indeed being dropped, but ...

The shared zeropage is read-only, which triggers a fault. IIUC,
The kernel then falls back to checking the VM_UFFD_WP flag on
the VMA and correctly generates a uffd-wp event, masking the
fact that the uffd-wp bit on the PTE was lost.

IMHO, explicitly preserving the uffd-wp bit on the PTE is still
necessary, since we're not sure if losing that bit is safe in
all cases :)

> 
> Certainly, I'll check the uffd-wp bit as well and get back to you soon.
> 
> Cheers,
> Lance


