Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C220FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CCB6B008A; Tue, 28 Apr 2026 03:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D4C6B008C; Tue, 28 Apr 2026 03:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C434B6B0092; Tue, 28 Apr 2026 03:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B57596B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:25:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39271160506
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:25:14 +0000 (UTC)
X-FDA: 84707128548.29.C7D1F57
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3BAEF1C0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:25:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BaHKK+yR;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777361112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCxxk2ZWIZ6775Ddt50SCJNnhpMNtd+lmo4iXra99RM=;
	b=sMscmk10bsVbciPV+N3lPOf8+VBYoIuz4uNZ2uN0A3o+GIRxm915F/A323TfTCOVyXHXC2
	PHGH5uPLh1vwPBtQCylSRNCAjvS9coO60ZItg6q39E7d1rktMSyN1czXbwuwOz2XjW4VXW
	A0JMeWQkQvenG5Pb3fUSphd3DFN0LAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777361112; a=rsa-sha256;
	cv=none;
	b=NEce1mPeyjv4x8XOxmXWYksyVkApN2FQdOtoaFRgDe2d3NM1Z8Xev09+2oB2ZCHy1gYWYW
	EWltQfn17Q0YCreZCvqBtbFMxLhK1KcBJ3ZZbysONNMHXD5W60N6qJBP7Ynv8ScHKhwXie
	uNY6qokMAwyUk/qpkifKCzDbsjpCK2s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BaHKK+yR;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777361109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lCxxk2ZWIZ6775Ddt50SCJNnhpMNtd+lmo4iXra99RM=;
	b=BaHKK+yRKCfLKa5fiwk4B0E+J2WDiD2jnmSw45lRSgk5ed/MjG/OFPve6pztHuJ9C0KSID
	+5qQA4XNDVuHdwjkh5KOvsX7mA8gA54Huo6FjkZazML4r/okshxJ1V9ScLp5Tjo/IZQ4TE
	+eUyfeBvDKqczc0Ur6ShL3ymex8pCnY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v7 4/6] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5dd84f9c-4ce2-4bc8-b644-e865f0623ba3@kernel.org>
Date: Tue, 28 Apr 2026 15:24:25 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0EC0552F-7394-49B9-91C7-A2E86CC0E541@linux.dev>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
 <20260426092640.375967-5-songmuchun@bytedance.com>
 <09298afa-9a36-4f29-a8e1-d4750c338df2@kernel.org>
 <C2E99AB4-CC47-4D9F-BF56-F971FD5A3C26@linux.dev>
 <5dd84f9c-4ce2-4bc8-b644-e865f0623ba3@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3BAEF1C0005
X-Rspam-User: 
X-Stat-Signature: 9h45gtix3mdcrcc3armexe4ezhqfbycz
X-HE-Tag: 1777361111-807334
X-HE-Meta: U2FsdGVkX1+I06fsdw3FQhnr1+UWnM4EvyqhOeP5RdbV4cqK0TON6hVXhg9L7CFWr8hrNPzjc+s3Hm7bspfWle8bQCEaxX8Q5i6Pw8bDUc5IuUc1hm3qUrpsR/Mjs5AtUuEeKq7HtNZtnhtGkL2DMGbsBaUD/jEBkC/wVDlMMPnnhpKCW2ATKlUhlMLTuPLikTqwaV6Q7zhFAFLmIwz2qtQZjHr+1twsX6E1JfrDAsZOrlJ7HyylatuGHDWGnOV+GWnPW39rz8mifQUGqp2+Qa627oJB7n3H4Nfo9bziIjBJ3vG9AScOmZiv0bpO1Z4y12nQfftsDSGPE9tkHy85abPVRRprJe0zKOJAlOcp2XHeY9QmOMlVFXzBDoP9ynH1YR34IVdKxemxLv1w6s/yYGdJGYPz4t9WROKDsJcatmAZ2a2Qv046bmaBOPy8ZPfBVb/j1cAk0GOMnHiRoror7wzOhWSPueAnIr1LcB86u+WZBJ/2TwHcRucNIxhWQ9QPMLtbroEjc7RIL0fZizG0AMLOZ7zS+Qu2cBjQ/E31enSs2KYrnuBSgvcNssDh4rmLHQcuklGBEKPr1ezBpBd9gVZbmhNGfZrgFVryzbNagAYPvpz3i+VtpA+oz5D9eebPlZ++Lhhbzg2nVxy93Jma5VkCFuyMcH0V0MVfLLbKXQqK7G9Fijv7jlovDtyA0+JkStCZQOmB/aps8TL+kelUYm4C7JHFPfrbqSRgJ0DPoRlN5E65eYu2bfnVlSxeds2nQ1PK0XCfW8dtcphbnnUOJS1hxeAvGIJTObQKRJuAvXgQ/w9wzC6j0mKt31PuyALIsxsUW5G+JNW8ZNlbuNXCxU2033WB2grkmC4rdNryQJyVlOj2z24MJKbPx6cOeHeMiFZwNbf9jLMb+OhRTkU1bBnklgIO1XvNr9seu3icHBpV2tUKKtpOH//5wFndU5WX1zN4mGuhxbVm3AphV/g
 jYRqiOyn
 SAOAo/xDj/mFkYuw08Zmpn/FCZKuiy6kTXpy+XtUItCSjN5OnOLRg/aEuc+1++adrwxDutpjdOD5Hg4TR0Ft9yzH5vq9VUwDLLW+ZN+QigzJd0tDsC26SagEAHKkpUQhpcHctvFRXqZwHYOBVXAYYiyyOkiu2VrYbsieLBU4qY39Up+Qe1hBgu7cC9SN1mxrpCIMcaT7nSBHv1j/uwd/TWAjpFt5TIWgLBcfZXNJ27hIG0yXEs2wfJ1AU3MXHxTalm6uj/W/0HsrP6CJ1EjM7imXIVYVUNIEWdg2i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 15:00, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/28/26 04:21, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 27, 2026, at 18:17, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>>>=20
>>> On 4/26/26 11:26, Muchun Song wrote:
>>>> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
>>>> counter in /proc/vmstat is incorrect. The current code always =
accounts
>>>> for the full, non-optimized vmemmap size, but vmemmap optimization
>>>> reduces the actual number of vmemmap pages by reusing tail pages. =
This
>>>> causes the system to overcount vmemmap usage, leading to inaccurate
>>>> page statistics in /proc/vmstat.
>>>>=20
>>>> Fix this by introducing section_nr_vmemmap_pages(), which returns =
the exact
>>>> vmemmap page count for a given pfn range based on whether =
optimization
>>>> is in effect.
>>>>=20
>>>> Fixes: 15995a352474 ("mm: report per-page metadata information")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>>> ---
>>>> v6 -> v7:
>>>> - Refine the alignment assertions in section_nr_vmemmap_pages().
>>>> ---
>>>> mm/sparse-vmemmap.c | 34 ++++++++++++++++++++++++++++++----
>>>> 1 file changed, 30 insertions(+), 4 deletions(-)
>>>>=20
>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>>> index 3340f6d30b01..01f448607bad 100644
>>>> --- a/mm/sparse-vmemmap.c
>>>> +++ b/mm/sparse-vmemmap.c
>>>> @@ -652,6 +652,31 @@ void offline_mem_sections(unsigned long =
start_pfn, unsigned long end_pfn)
>>>> }
>>>> }
>>>>=20
>>>> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, =
unsigned long nr_pages,
>>>> +  struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>>>> +{
>>>> +  const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>>>> +  const unsigned long pages_per_compound =3D 1UL << order;
>>>> +
>>>> +  VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
PAGES_PER_SUBSECTION));
>>>> +
>>>> +  if (!vmemmap_can_optimize(altmap, pgmap))
>>>> +  return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
>>>> +
>>>> +  if (order < PFN_SECTION_SHIFT) {
>>>> +  VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, =
pages_per_compound));
>>>> +  return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
>>>> +  }
>>>> +
>>>> +  VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>>>> +  VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>>>=20
>>> I would just have done that at the very top, as this check applies =
to all cases.
>>=20
>> My initial reasoning was that the current formula holds for compound =
pages smaller
>> than the section size, and we only need to impose limits when the =
page size exceeds
>> it. While the current callers of section_nr_vmemmap_pages() don't =
pass sizes larger
>> than a section, this will change in the future (see [1]).
>=20
> A function that is called *section_* will get a range that exceeds a =
section?
>=20
> That sounds conceptually wrong, no?

It does seem a bit ambiguous. I will rename it to something more =
appropriate if I
expand its functionality in the future. For this series, I will update a =
v8 to move
VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION); to the top of this =
function.

Thanks.

>=20
>=20
> --=20
> Cheers,
>=20
> David



