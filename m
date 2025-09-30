Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C82CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 01:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203B78E000B; Mon, 29 Sep 2025 21:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB188E0002; Mon, 29 Sep 2025 21:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1181C8E000B; Mon, 29 Sep 2025 21:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3E8F8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 21:53:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B44261DFF84
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:53:27 +0000 (UTC)
X-FDA: 83944244454.24.F503372
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id CC68A140002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:53:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GKtcpK/H";
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759197206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ch7Q5TgnPok++zD6SAUojpj+InJhxzN/ETKzPzMNocY=;
	b=Yj4slAOyWbmif9GOzqR+OOrl1lYc1L3c7jQZyZHXr7ffCBXYB6oBmnz374UkE7ilAvzyFa
	YZZhnGxXcKXNUo8ibHM8O9q/mZPlBeAtv06fp5dm4rojdeSQjmfJTy21bCKJin+oMr+D2J
	XQoIfZgnvbMda8iBcuiEebc6GK9Q1qU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GKtcpK/H";
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759197206; a=rsa-sha256;
	cv=none;
	b=X4Eu/zoRNVKDV6AFKIrIdukFg7vN6E+gVh1r724DekI5QWI+57Kf6IE7dOPRt/G4U9v0HQ
	c9/rSDLNnQMoc91VRJSSJuLZS4pLyJbrKvXkY0nK0G03PR4nnBXJuWOFgxqRav3oxkSNtU
	jkqu4IdqdToqjrGrZXrBj/TLkfVJ9yg=
Message-ID: <01200dfc-f881-4d09-ab52-c5b7944af0d0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759197203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ch7Q5TgnPok++zD6SAUojpj+InJhxzN/ETKzPzMNocY=;
	b=GKtcpK/H3udWTBPYkB4ydbSTFKIOoUDTEEoJv73sh5+CqWioHoKYIbcYTFsFvB04HPuhxD
	Ue/C2yQ2yPycp7yxWsXIVzrt7jEnabTZU0H+n1+2g3VsD1ozbxw9DqnYHZo7fcJJlyZvrM
	1In1epsu/OA54NgKu7glJ2SjuKNll/g=
Date: Tue, 30 Sep 2025 09:53:08 +0800
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
 <0701c9d9-b9b3-4313-8783-8e6d1dbec94d@linux.dev>
 <1718aee4-1201-4362-885b-e707f536a065@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1718aee4-1201-4362-885b-e707f536a065@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC68A140002
X-Stat-Signature: xd4bj4jp4mw6jqpjyrsux9bz4ughn5pb
X-HE-Tag: 1759197205-539397
X-HE-Meta: U2FsdGVkX1+K72xJe2qkjr5CyoSFuCdnO95Ml/BwkYDyHyR7e0Qfli1eU2tu1j9asRAtKJBZxziq79cqUs5fSztkighlVqg912w0yGPENqm86wRtWn1A5NGKR9KcS37qigR7horY7gvU/vF6Ys+pxGewB0iSYEg+dOqydsSkrtLFrMYJXXp0sp1TZZPAnBXFBuLafuiGzfy4fnwG4/el0tIROUcQAm2pqh2gM6Q734cKIMHkswWbmztXRBM2QsV8hczzrUqxBcHvAcxYjHuVr8CaK99BQygwzywyJPn5wR3A2IUjAnWfVjyJM23kI2XgRXaD8sk7wtgyOWKP4J6GrmD+BxrukhHBfKvaw8RuXVVhoZH0rNVCkyGGTKyHc8QXuqNuVSrd/bNhhM41tvrWR11Xljldi9tUZn38jPBVAUR6CQP9EzpHtCVFjT2X9dkpFmhHE9VggOMe3KFoEHP2wO06HnN86e7OnS6SWvwihr+V2PRdpTRwSoUY2xcVJ/dOlq6jMKnB64c9lvm6y18kzOMT/Zhes8FjsDPuL+Ej7cFxp/AQ+EUoEknwwDotm8nKdtqbhWTVKdzV+dPS0tJigByuAK72FtSr4XlEDkwzFD3fgclyLANwtfw8S4B1x1dD4A3ltvlblWoPeCwB6ZHqraGWfTFsqexhamdN1uNOtCJeiTf8b5oSKFDwrEVpJEg7ggRvCNr7cbUN/AXy5gIjAHK27QcR4nwnoVHwnIG/paXJaG8m1pPGqe206qv6Gu0qELQKruFM+Hn9Ei3Jrx9bUKN4k16D96QZSbAV1ViSz5Mj5pHgQKbLp8WVkwOeLWN5DPVfvuJ19ESpAEDBcwjJU5G25RiC8zu26gevX52IPz3XR+b4gpK2R0noS3vXKx9td0FALpp08tf924Qk35HNJcNDP/HzbXXtn4q1egHXSUWJT5f10Mlb3vA40C6QeQ8Hz5Mc8+SJctMc1HScALN
 lsw+cSXK
 zD0etqTA6EjmNOTvL6VTWW60hpJjLZRy7GrgmVlwVl7QwKSegnVFCJ+qMbZGIAv1v5nJ2NKhAy2sasDMy4K6//IO2wxWdJUQqgaJ0U0VKR/LT++wJzFC0w6QI3SbwddMXV7LowyRw+pADz1BxedXugmKuCfkr85gIiS4kRsCkBTZo3uXbTY8AzMxAG/EfQ00sSqxfJrwZObYAaQLFOk80dU2coqYy46d+02yjTZLzP94Cp2iZuAEkMmObe5FPso3M4289xJO6xQRQwFJpDyZvcvkS+6/As3hWZ8PomO816/EGGUaak655wOv21xV2G71J2s6/oTojtF+2SNFgdwrk6rZgHGJhZEn74+GJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 00:11, David Hildenbrand wrote:
> On 29.09.25 15:22, Lance Yang wrote:
>>
>>
>> On 2025/9/29 20:08, David Hildenbrand wrote:
>>> On 29.09.25 13:29, Lance Yang wrote:
>>>>
>>>>
>>>> On 2025/9/29 18:29, Lance Yang wrote:
>>>>>
>>>>>
>>>>> On 2025/9/29 15:25, David Hildenbrand wrote:
>>>>>> On 28.09.25 06:48, Lance Yang wrote:
>>>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>>>
>>>>>>> When splitting an mTHP and replacing a zero-filled subpage with the
>>>>>>> shared
>>>>>>> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-
>>>>>>> dirty
>>>>>>> bit.
>>>>>>>
>>>>>>> For userspace tools like CRIU, which rely on the soft-dirty 
>>>>>>> mechanism
>>>>>>> for
>>>>>>> incremental snapshots, losing this bit means modified pages are
>>>>>>> missed,
>>>>>>> leading to inconsistent memory state after restore.
>>>>>>>
>>>>>>> Preserve the soft-dirty bit from the old PTE when creating the
>>>>>>> zeropage
>>>>>>> mapping to ensure modified pages are correctly tracked.
>>>>>>>
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage
>>>>>>> when splitting isolated thp")
>>>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>>>> ---
>>>>>>>     mm/migrate.c | 4 ++++
>>>>>>>     1 file changed, 4 insertions(+)
>>>>>>>
>>>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>>>> index ce83c2c3c287..bf364ba07a3f 100644
>>>>>>> --- a/mm/migrate.c
>>>>>>> +++ b/mm/migrate.c
>>>>>>> @@ -322,6 +322,10 @@ static bool 
>>>>>>> try_to_map_unused_to_zeropage(struct
>>>>>>> page_vma_mapped_walk *pvmw,
>>>>>>>         newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>>>>>>                         pvmw->vma->vm_page_prot));
>>>>>>> +
>>>>>>> +    if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
>>>>>>> +        newpte = pte_mksoft_dirty(newpte);
>>>>>>> +
>>>>>>>         set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, 
>>>>>>> newpte);
>>>>>>>         dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>>>>>>
>>>>>> It's interesting that there isn't a single occurrence of the stof-
>>>>>> dirty flag in khugepaged code. I guess it all works because we do the
>>>>>>
>>>>>>        _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>>>>>>
>>>>>> and the pmd_mkdirty() will imply marking it soft-dirty.
>>>>>>
>>>>>> Now to the problem at hand: I don't think this is particularly
>>>>>> problematic in the common case: if the page is zero, it likely was
>>>>>> never written to (that's what the unerused shrinker is targeted at),
>>>>>> so the soft-dirty setting on the PMD is actually just an over-
>>>>>> indication for this page.
>>>>>
>>>>> Cool. Thanks for the insight! Good to know that ;)
>>>>>
>>>>>>
>>>>>> For example, when we just install the shared zeropage directly in
>>>>>> do_anonymous_page(), we obviously also don't set it dirty/soft-dirty.
>>>>>>
>>>>>> Now, one could argue that if the content was changed from non-zero to
>>>>>> zero, it ould actually be soft-dirty.
>>>>>
>>>>> Exactly. A false negative could be a problem for the userspace tools,
>>>>> IMO.
>>>>>
>>>>>>
>>>>>> Long-story short: I don't think this matters much in practice, but
>>>>>> it's an easy fix.
>>>>>>
>>>>>> As said by dev, please avoid double ptep_get() if possible.
>>>>>
>>>>> Sure, will do. I'll refactor it in the next version.
>>>>>
>>>>>>
>>>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>>>
>>>>> Thanks!
>>>>>
>>>>>>
>>>>>>
>>>>>> @Lance, can you double-check that the uffd-wp bit is handled
>>>>>> correctly? I strongly assume we lose that as well here.
>>>>
>>>> Yes, the uffd-wp bit was indeed being dropped, but ...
>>>>
>>>> The shared zeropage is read-only, which triggers a fault. IIUC,
>>>> The kernel then falls back to checking the VM_UFFD_WP flag on
>>>> the VMA and correctly generates a uffd-wp event, masking the
>>>> fact that the uffd-wp bit on the PTE was lost.
>>>
>>> That's not how VM_UFFD_WP works :)
>>
>> My bad! Please accept my apologies for the earlier confusion :(
>>
>> I messed up my test environment (forgot to enable mTHP), which
>> led me to a completely wrong conclusion...
>>
>> You're spot on. With mTHP enabled, the WP fault was not caught
>> on the shared zeropage after it replaced a zero-filled subpage
>> during an mTHP split.
>>
>> This is because do_wp_page() requires userfaultfd_pte_wp() to
>> be true, which in turn needs both userfaultfd_wp(vma) and
>> pte_uffd_wp(pte).
>>
>> static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
>>                       pte_t pte)
>> {
>>     return userfaultfd_wp(vma) && pte_uffd_wp(pte);
>> }
>>
>> userfaultfd_pte_wp() fails as we lose the uffd-wp bit on the PTE ...
> 
> That's my understanding. And FWIW, that's a much more important fix. (in 
> contrast to soft-dirty, uffd-wp actually is precise)

Got it, and thanks for setting me straight on that!

> 
> Can you test+send a fix ... please? :)
> 

Certainly, I'm on it ;)

