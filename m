Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC1AFCA192
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 21:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4A36B0088; Mon,  9 Mar 2026 17:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7BA36B0089; Mon,  9 Mar 2026 17:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB57A6B008A; Mon,  9 Mar 2026 17:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C798B6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:35:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A79014039E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:35:05 +0000 (UTC)
X-FDA: 84527830170.29.4E553F7
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 784D940006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:35:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UfIiuqUj;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773092103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Z89Z0CbGlfYyK9enL1aU6uEk1uYUJc2hi9of77FKCc=;
	b=gQTnznchqw3fObDHuQuQxoJYhLvfgzhb8TdbJh4P5aonIAhqExOtxJfdo6bKRs3mG+erl7
	xJ6E8DSriSd39a5ujObMt/Ib9Yve14eoMMDk06YkaxFkYLTNkKXa4vAxQec8LlucqHMWCS
	HgSd5dWDbIwLck0TrnXUtbaGa2QawNQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773092103; a=rsa-sha256;
	cv=none;
	b=TbqE8Ev/jJothAjTGq84BWmXCc5yQVskK8z8o5aBzL/FvtKgQ7/qqriXKR0elDSZZujJaG
	ZSq4IGa02fWI3IZBMdKYRY+vKxpPZzrHBuqMuMJ9rLpejm+RqZ3FPP7yShzGhp98XY/foV
	NZVqxBgsuxAXn4RcMNv5WZ2WBnhgIzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UfIiuqUj;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <de0dc7ec-7a8d-4b1a-a419-1d97d2e4d510@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773092101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Z89Z0CbGlfYyK9enL1aU6uEk1uYUJc2hi9of77FKCc=;
	b=UfIiuqUj5RN4OnUp4DNTD94bNDfHXU/WZAsxKKJI+0HRS89NtQj96WZrCoQLc2+MRaJK9s
	E3IB3pqneljaxU6hi6H97Os7emjBXks+52uiFFqGOY8CELSXzuwd1DUHfPtD1cG6LsElAj
	bpL91EN1nFg/AuG8ETeRKDtWEndcmAs=
Date: Tue, 10 Mar 2026 00:34:39 +0300
MIME-Version: 1.0
Subject: Re: [RFC v2 12/21] mm: thp: handle split failure in device migration
Content-Language: en-GB
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <20260226113233.3987674-13-usama.arif@linux.dev>
 <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
 <6982e9fc-cc17-4d4f-b26e-83997c4bf070@linux.dev>
 <CAA1CXcCb6aZnjgtunEuwL380S-2re9N-AEjZUB+XO9G6gkrHQw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAA1CXcCb6aZnjgtunEuwL380S-2re9N-AEjZUB+XO9G6gkrHQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 784D940006
X-Stat-Signature: ze96k5yy7j7kn8sfic7gh797ptex8fd6
X-HE-Tag: 1773092103-556291
X-HE-Meta: U2FsdGVkX1/+Np2dvAturbGp2YNhLufgKUKcj4Vg7FZJfW/T3tbGo6nHVlb/jiDuys/KJoNkJj3FrtCD+DT2KKJVVL21uW5cCbB1z+VI2c3JzY9wgI1iDH86aVgvaq4mH+nfNXUOGPTLi3n7ufrufC8uAbseL5YxJQg4Bg1xCioNGVpvXsicdScosE5eLbghmUic4WVV2KXrskghevS08zN3L7PlHJEgfe+GrJBL/kjiSvHiP+nmBdVmvqHFtT0yldwSTROk3nFrWxq/pSl5pUrkDo+maSWz2ZonPcZRdyj2uHRRtZ0aiyJyB+ss7pZnETaRJKsZqLOB0j7j6Xe/TzN27Qswmzui8bkXRdC4G3H3KImSZBuivc0NjLKrhVvDVJh6GhwOkMHhFjFwdhBKqVfTXzVx/nJC7xxd48X+qFsLDG69j3GKpo3DVZrCtZDcvbiITlrqPAvTs6wHfp2rtBPWyDoRhj2ZS3VOe8lWbGYlE/mUuoZWxAvy2h6xdAgiP+fC5J7wZHyfck/ooZoJ44BHCY0wSX4/n2+W1Pc0r/HnWBvSEJZKRVAIYKJypr6ojZUTgXpad6imOr854s/hso51azXvrdkFCwgvT/FBRQTVPFr/V5Ity/KTUgUtD9EnzAFe/fkEVDi6PX5e44uEyBI90CwAQxOosXAY2fuTpFi44ZAoD2tnZFmuanc9/don+mWLxJzechkY/ED92tSKNzlFulXp2lkdexdUqm9dsfW/swAG3a0bTQIgGMr7WP/02EprSTwiLwll9eOhfsga/CwOAeixkNUfuB+Ek4Cd6RF166vvq1HHRqYCFpnuhKKlB/7XEnAkz/hjpAeyUCCv8TQ7EP664t27i3nh4Fe/aZj5z20RB6XIPZd1Dfw7qn49ll4gkiBxOFNs9+KgE63IFZyLijlZkAdfs6T//q9SHhPcetyi520f6ljeOlZ3/7p7DR86j4VjSAE+Mrnlhqj
 q1QQHbof
 dU9/PGZeHZPrNxcQ69iiGDCEU49pxESid2sYuHDZzalsR4mcn/z3gWoPZafpOdzas8Jx3gPL9k44iJmmHZKl5x2oJ+XPq6Xzid7j1vMIfCRAqinExYoDcQw9JLKCdsuM4vOxN9VcQWPzM7y2688h1nxCEpmIOO+gE7svHQwZnkThLR3pLKhXY8/POK9qg5Dr5Hf4CAHqp8hN+tpAUZtCpO62HTFKP30IaGBKnRfhbFrwUFz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/03/2026 18:09, Nico Pache wrote:
> On Thu, Mar 5, 2026 at 9:55 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>>
>>
>> On 02/03/2026 21:20, Nico Pache wrote:
>>> On Thu, Feb 26, 2026 at 4:34 AM Usama Arif <usama.arif@linux.dev> wrote:
>>>>
>>>> Device memory migration has two call sites that split huge PMDs:
>>>>
>>>> migrate_vma_split_unmapped_folio():
>>>>   Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
>>>>   destination that doesn't support compound pages.  It splits the PMD
>>>>   then splits the folio via folio_split_unmapped().
>>>>
>>>>   If the PMD split fails, folio_split_unmapped() would operate on an
>>>>   unsplit folio with inconsistent page table state.  Propagate -ENOMEM
>>>>   to skip this page's migration. This is safe as folio_split_unmapped
>>>>   failure would be propagated in a similar way.
>>>>
>>>> migrate_vma_insert_page():
>>>>   Called from migrate_vma_pages() when inserting a page into a VMA
>>>>   during migration back from device memory.  If a huge zero PMD exists
>>>>   at the target address, it must be split before PTE insertion.
>>>>
>>>>   If the split fails, the subsequent pte_alloc() and set_pte_at() would
>>>>   operate on a PMD slot still occupied by the huge zero entry.  Use
>>>>   goto abort, consistent with other allocation failures in this function.
>>>>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>  mm/migrate_device.c | 16 ++++++++++++++--
>>>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 78c7acf024615..bc53e06fd9735 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -909,7 +909,13 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>>         int ret = 0;
>>>>
>>>>         folio_get(folio);
>>>
>>> Should we be concerned about this folio_get? Are we incrementing a
>>> reference that was already held if we back out of the split?
>>>
>>> -- Nico
>>
>>
>>
>> Hi Nico,
>>
>> Thanks for pointing this out. It spun out to an entire investigation for me [1].
> 
> Hey Usama,
> 
> I'm sorry my question lead you down a rabbit hole but I'm glad you did
> the proper investigation and found the correct answer :) Thanks for
> looking into it and for clearing that up via a comment!
> 
> Cheers,
> -- Nico
>

Thanks for the review! There is a need for folio_put in this patch
specifically for split_huge_pmd_address which I wouldnt have figured out
without your comment, so really appreciate it!

Usama

