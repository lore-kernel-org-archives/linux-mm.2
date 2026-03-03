Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F050DEC142E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633516B00ED; Tue,  3 Mar 2026 06:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B64D6B00EE; Tue,  3 Mar 2026 06:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E33F6B00F2; Tue,  3 Mar 2026 06:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4D26B00ED
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:16:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA58A4B579
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:16:37 +0000 (UTC)
X-FDA: 84504498834.06.B7C4199
Received: from sender-pp-o92.zoho.in (sender-pp-o92.zoho.in [103.117.158.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9178E40003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:16:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=RJ8VRa00;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf27.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EndSrgcBhRr8R7/KqjhtMiZuGQSe3hROtclvWoUJ0JE=;
	b=p2QJIM68Tnyln6ico2BcXdf0+92ZLvRSZpp5eptu7TT1VXDJ79wT/FdxF7jMJvF++xkl42
	QBbUPgl8F/x9Sc0GFCqXsOnn5OR9lWM4vlkexB1IC+1+0PDtNfWxr3kSHX+4GISEXKY4T3
	S9fVUGFJnNtUyXU5GwLcy9H99EOpapQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=RJ8VRa00;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf27.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772536596; a=rsa-sha256;
	cv=pass;
	b=yYwrh6yjfe7xqnv5zCGzgl43d+YHzfgoLu2Qltdm9l021xIc/QnEcKReUskOzEp//E96sR
	8R88e6N3UCYG29pdulxwASiwWdHM9teXTjTVM7yEA/kyYhRrwpehnj84+K9RhRwiRs9/Ho
	tf+SoPJJgo/MnyxDwXB+qSYPBItazUM=
ARC-Seal: i=1; a=rsa-sha256; t=1772536583; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=c6uMVhD86CKmKHEBvBzbbEGUO545/NmTSkBXcfab2JufwYbclv1Bm68cyEodJ1K4HtbYd7sJDVtDYgZJZ2PqTZhu5l8a+fkuGeUE6wgf3V/yZ9VH7sCg6A7Sn5scPkXigkbuENkWS/XE8vrQtHbA53UitgAZqcLTU33ch9gDWw0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1772536583; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EndSrgcBhRr8R7/KqjhtMiZuGQSe3hROtclvWoUJ0JE=; 
	b=Phvn01ae83Ju5MY3qI2hbtlfxjP3eGRxQ927RNpjtpWtw+Od4Wxs6YUP4jYI8n/zmKcLosoSnoTxj5pCpKd6tAi2Alc4E2rRzPxYKE2xtDJ25Agg7dHHeMmAeq4T+Z8hbIWyXf3wJcyk1pOhGKaMdPdLXQDrFLN8Uy+XxR0Tb7M=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772536583;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EndSrgcBhRr8R7/KqjhtMiZuGQSe3hROtclvWoUJ0JE=;
	b=RJ8VRa00D6MZi8a/Tc4vU3PE5/as1s11xtoKaaxw7bPUQe2nEB6fDgS7A1lhBhyL
	SB3jT71LxG/dJ0VYNneCOWISGnOwTykQ5fV5UAu8Y8JWxPcmEfxADTBp5UPPJMFLHhn
	BpouBOXHguRWruvGHEtdoP3uKvczjYKtV6OeXMXY=
Received: by mx.zoho.in with SMTPS id 1772536582470518.9141615654373;
	Tue, 3 Mar 2026 16:46:22 +0530 (IST)
Message-ID: <c7984a95-5dd5-41a5-b59f-f993307b99b8@zohomail.in>
Date: Tue, 3 Mar 2026 16:46:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
From: Shivam Kalra <shivamkalra98@zohomail.in>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
 <20260302-vmalloc-shrink-v1-2-46deff465b7e@zohomail.in>
 <CAH5fLggLgRJL_5a2Ky-Ag7E6iRdY1wAVA=yx4wtz16-q+CMAGg@mail.gmail.com>
 <57b0ef75-59c2-44b4-90fc-d1b50cc1e9ed@zohomail.in>
Content-Language: en-US
In-Reply-To: <57b0ef75-59c2-44b4-90fc-d1b50cc1e9ed@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9178E40003
X-Stat-Signature: hsu5w33jxwndq5mr3q4cgrrwc5aqh8o3
X-Rspam-User: 
X-HE-Tag: 1772536595-768822
X-HE-Meta: U2FsdGVkX19biMLYxO2CSkL61utMMpetFlJI01+x06Nne3dWDgcw/5CDGXy2Kur+u44Lu146aSszQVj9kNs4+LzqaeCnt3vzb3F6N+WnFCeP0864j7ZzngZ0LcXMOCn4pFpVYFg1KAYcUq307nDDRYrYHgwPalCaakiwn8JRtKUAh3dMjQnqzPsCVLqtj3skOvrjdXcjTLRiLICsULEsre/J5wmgjUSbSqSplI0gwfHnLl4uEsmAAclfZ+auEidtMngKvf1LFFdBa46XQTD/C01g+rvPrDyC9HnOm8d2SY7lL9bCG+4uD5Az/8Zy+w6mlJM83OxFYWlnvbMiOnmHZH6SyGEN4wDnWdwQEI2qHSAQ2flu2alYIN6pp+ATSbY0mR/NcCPharoLmlGKPRYFYx0lyPS4zbHIerwhtncTGZIspmlYrEGmdp/IEhHQc3GTqo5C3oOV+/5kVKbWx7mXIhiONodcIX7mlpQ2QhOyD1UwNQ4wOjjYbQAPatgvbpSiqkad6dE5Mws5MtSuXtShCM/YWtC/18Js23O35MiTvjk3qU+zsbMByQKGx8SJwgQADWqLzwTNLFbAC+AO3+Ua2NY9+cIxsP2hv+eOTzf3OFYP7yC05Dn0YOvEyqTDaUKmdUFcUCxXfBFt5KvcSDXuZk76bU3krBPaA+yHSFc/w4K1BMrpSD/Bk/+MdUxt4hh2sT7bjaR8Q/N4ZA7MC39tXqBxbZaTQ4yl00HFOTr/i4HMPB456HhhPY2VYRCTy/wTCUW5t+mQBh7x5ftZBzoEYbrQZ5nslgChYmH+4d2eAWtofqaBS2XAot9VMgq+FpjoWLgNhijxmZ3zDBridLHePKF8/O2i46L9i04/ahULAEc/YGKOHAarooKeDghI8qC9ZwmIBYhPuEQtrDShqzeCKbdHe9BjxYEM3j/lbvQ3k2m/6Ljm9gtCzfs9D7c+PyiHGz6xovx/NWMIri5Anig
 GLMMCK61
 /lQyFpYccxKwcXnxRjAKs+qjtdjtCqK9cxYPm8PoHIM/OJc/IyX1eIA4YKv9ik52VxvGyeBvoDoC3/z14uUBEyZLUWvCvhFQLzdGVFQf9BxTAwcpzQi8Ii2qlmGem6ud7+oJvg7Zs+QQe4olU51JFQAdCw0nRPa/ZWqmUZr367WgPzTcC6DFhhzrUio1zMXr/OrISnlANtkzK1Ap0zDzdgo4T6eTLjnUTsXzAjyDF7g+vPyhvofwWn6Mf1Bq00W9mxMyjLXjq5DgTBVevqhR4xzmf74QeJHUkqaquDP1ixCikb2jkghobDe46TjTzMwP4KbANteyebuLCo336jDW5Y3zzVd2Xf8YW64r/Zroaj0G75Ns+j6qo1kyj9Eu6rKPOv5JW3aUIsxX+l7nuWIXdl8SHlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/03/26 16:42, Shivam Kalra wrote:
> On 03/03/26 14:40, Alice Ryhl wrote:
>> On Mon, Mar 2, 2026 at 3:03 PM Shivam Kalra via B4 Relay
>> <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
>>>
>>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>>
>>> When vrealloc() shrinks an allocation and the new size crosses a page
>>> boundary, unmap and free the tail pages that are no longer needed. This
>>> reclaims physical memory that was previously wasted for the lifetime
>>> of the allocation.
>>>
>>> The heuristic is simple: always free when at least one full page becomes
>>> unused. Huge page allocations (page_order > 0) are skipped, as partial
>>> freeing would require splitting.
>>>
>>> The virtual address reservation (vm->size / vmap_area) is intentionally
>>> kept unchanged, preserving the address for potential future grow-in-place
>>> support.
>>>
>>> Fix the grow-in-place check to compare against vm->nr_pages rather than
>>> get_vm_area_size(), since the latter reflects the virtual reservation
>>> which does not shrink. Without this fix, a grow after shrink would
>>> access freed pages.
>>>
>>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
>>> ---
>>>  mm/vmalloc.c | 25 ++++++++++++++++++++-----
>>>  1 file changed, 20 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 54e76a47e995..7a4c59422638 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -4327,14 +4327,29 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>>                         goto need_realloc;
>>>         }
>>>
>>> -       /*
>>> -        * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>>> -        * would be a good heuristic for when to shrink the vm_area?
>>> -        */
>>>         if (size <= old_size) {
>>> +               unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>>> +
>>>                 /* Zero out "freed" memory, potentially for future realloc. */
>>>                 if (want_init_on_free() || want_init_on_alloc(flags))
>>>                         memset((void *)p + size, 0, old_size - size);
>>> +
>>> +               /* Free tail pages when shrink crosses a page boundary. */
>>> +               if (new_nr_pages < vm->nr_pages &&
>>> +                   !vm_area_page_order(vm)) {
>>> +                       unsigned long addr = (unsigned long)p;
>>> +
>>> +                       vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
>>> +                                    addr + (vm->nr_pages << PAGE_SHIFT));
>>> +
>>> +                       kasan_poison_vmalloc(
>>> +                               (void *)(addr + (new_nr_pages << PAGE_SHIFT)),
>>> +                               (vm->nr_pages - new_nr_pages) << PAGE_SHIFT);
>>
>> There is a kasan_poison_vmalloc() call here.
>>
>>> +                       vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);
>>> +                       vm->nr_pages = new_nr_pages;
>>> +               }
>>> +
>>>                 vm->requested_size = size;
>>>                 kasan_poison_vmalloc(p + size, old_size - size);
>>
>> And there is a kasan_poison_vmalloc() call here.
>>
>> Furthermore, they seem to touch overlapping ranges. Perhaps the first
>> call can be dropped?
>>
>> Alice
> Thanks for the feedback Alice. I will do two things for v2.
> 1. Update the base-commit to the recent most commit on char-misc-next
> 2. Keep only a single `kasan_vrealloc` call after the rebase.
Correction: since this is mm, I will use the mm-new branch.

