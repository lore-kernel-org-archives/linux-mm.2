Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05733FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 06:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319036B008C; Sat, 25 Apr 2026 02:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0556B0092; Sat, 25 Apr 2026 02:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D296B0093; Sat, 25 Apr 2026 02:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11FC46B008C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:57:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AAED1B73D1
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:56:59 +0000 (UTC)
X-FDA: 84696170958.21.E1EBA42
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C48A20005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:56:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AylBSejQ;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777100218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYW2ifPKRCyV2PZsOeVHbuMLyGxnS6SER91CdDGNAFY=;
	b=1R+JABqMU6zrD3kryYgSZh5D3YXgK0MZ/wDS/b6k7Ax13OQ0EUsKac4HAfpAMVtt/8/VbF
	fl9DSX4wL5qAXxYxz28X7tDC7lKIiwLXC8a/GG+R8Gj2MPFPXUjpr8mO2HbGywr6L+S4q3
	TXCe+rkoyAy01Np2prG3f/e0MLlPItQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AylBSejQ;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777100218; a=rsa-sha256;
	cv=none;
	b=dL0ms2prENlegqABxnwGYbEUYLQkaSPq6TFhFH/iy7TnF2QYT8nsno6YxFe3FQLajZrXYj
	wv5+LHOxjStmo/5PirUD6O0IZXIkqgC5S0O9GBErMvgzVgsxPsN9LIayX/wFFLbShYZxcN
	xKJUvhdvCnNpG1n70UvX0uTbdKjpkXQ=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777100215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zYW2ifPKRCyV2PZsOeVHbuMLyGxnS6SER91CdDGNAFY=;
	b=AylBSejQND587ibmfjqlB+qxK/iMR3t6ePfxNQ/RCPD5Bn1YQY3gQxZPjp6uA1fwooxo0r
	MFccirkxba+ZFLzmxT0TETdP1wZKBks/Kn/wJycgtRE1uukvpHOZLMK3RN8kZX+h6D+f8A
	VUjicK463RCC1H+5n817ZUiXvfh8Ftc=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Sat, 25 Apr 2026 14:56:14 +0800
Message-Id: <7B037C2B-A0DE-4C49-9BFF-4B4D999A218D@linux.dev>
References: <2e664019-f161-44d9-a3fa-74c4d8290345@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
In-Reply-To: <2e664019-f161-44d9-a3fa-74c4d8290345@kernel.org>
To: David Hildenbrand <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C48A20005
X-Stat-Signature: bmhanno6mayb513mimbw1jgb75ws6r4t
X-HE-Tag: 1777100217-239321
X-HE-Meta: U2FsdGVkX1/tZ39zM3eDwyHMG3tRCr7aHfwG8/sBBSqvlu50rRim7ARVgyhUXptZJAEvQaEP+8GtCt+KABGOJYVJEbobOCiqmjd1xPjC/bj3E7eyiITuS0F+SXj1Wgr1I0CJepexzGgM24dby34/g25G6WmsVY8+iHLUEKk4WXzMxYOEujHCAFtJdTXyKvZcArF0bR+140mEX3ubCvWJ+npBdBVJs2JJWn/QNt5/nzlWeAXa1CBIo0JJ4je8UtRcWCnY8ZHbw3ok0g1nJKcWwQvo/MX5C+xJl18o5mog3EY1Um4rOpKAwgY+whilIZ6H+BFUMNelwmUyV09Dx8e8YNJR/4YA3P/v2/dgNO72Yr4VEK16PZ3qQoUdNModALp+SPQc/KGkJBSkCSrJuPsM0MnpJXYv8nxegPPXt0imcbTtl2ejRPwhk0kfXYMEGc4kWh6qNNMA58zamOyZ3pfswxMzaPyaN5NrD8KZ/mXZ/JwjT8Xy0kbqd/dfwMQwDKaj2PzVFi3ricPT1Iuff4UhzRwleECowjV7OxYlSoQHieGp2ud7R6cGVRL1JtysKFUhy4WKumrxPx5S6t9ZUPxa8kIZpP1nDWlqTPr7+oRSKwvbaB/Uz64LxPAZBYouDt2UDGJ3HJX6PrUxc5/LW7LpcPYHChd3FxtIsNpLOwU1gFuGjzMjf5KLP2+d7y5ft22J+hCkz5EkIso7wvphcnbh2No4T2WlUDE7btzLIvQs2ABowd5C//EDXnIx1kAc+wH/5GG15mVWzbJex2/5r99YQdWYyIm2jIKPYEu2yAbJN5zCnWztx6Kq8YlA8vqEHPdqiKdOAMm8VewNM+bKJmVYRlCvsF3W5PuXg60w6ywqoHDxpL+p02HRKjUOJzDJFndEInezxf4Px6hOh6HaKoPqwkVKz50elFb7jFkbwU1CJhepGqDvB5XytAXqfYJnuxugQFz2nPoMImaGLJOM/jE
 MONwSZ8k
 G0r6y8bQWttRlJjcJTNVYgR9wyTyLUfr5nW02UIHtE5eoWoBJ87Y3OzLkse280+FcmSyf12exd6GUY031T/DUvEghYkilJFHzP8d5/KrpRjxhZn1v126QSv9yCGKRP6hQVAyP3su3WNLoNp3oSTGsbwZLUqenujkDhV0P82lDwO9E+sfcjTI9+/8FqF9/Cbxb/9D4q4eHTSQYdcqOx/1vSjvCCmLFS4I0PemmVcI/W08i/CVfBjBWJSAJ1QXU76yRS9+v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 25, 2026, at 14:47, David Hildenbrand (Arm) <david@kernel.org> wrot=
e:
>=20
> =EF=BB=BFOn 4/25/26 08:20, Muchun Song wrote:
>>=20
>>=20
>>>> On Apr 25, 2026, at 13:48, David Hildenbrand (Arm) <david@kernel.org> w=
rote:
>>>=20
>>> =EF=BB=BF
>>>>=20
>>>>=20
>>>> Hi David,
>>>>=20
>>>> Sorry, I missed the 1GB hugepage scenario earlier. Given that sparse_ad=
d_section()
>>>> operates on a scale between PAGES_PER_SUBSECTION and PAGES_PER_SECTION,=
 the pfn and
>>>> nr_pages parameters wouldn't be aligned with the hugepage size (pages_p=
er_compound),
>>>> but rather with the PAGES_PER_SECTION boundary. Do you think this expla=
nation makes
>>>> it clearer? In the interest of code clarity, do you think the modificat=
ion below
>>>> makes it easier to follow?
>>>>=20
>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>>> index 2e642c5ff3f2..ce675c5fb94d 100644
>>>> --- a/mm/sparse-vmemmap.c
>>>> +++ b/mm/sparse-vmemmap.c
>>>> @@ -658,15 +658,18 @@ static int __meminit section_nr_vmemmap_pages(uns=
igned long pfn, unsigned long n
>>>>       const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>>>>       const unsigned long pages_per_compound =3D 1UL << order;
>>>>=20
>>>> -       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
>>>> -                                   min(pages_per_compound, PAGES_PER_S=
ECTION)));
>>>> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTIO=
N));
>>>=20
>>> That here makes sense. We can only add/remove in multiples of PAGES_PER_=
SECTION.
>>> I think what we are saying is that we want that check in addition to the=

>>> existing min() check.
>>=20
>> Right.
>>=20
>>>=20
>>>>       VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) !=3D pfn_to_section_nr(pfn=
 + nr_pages - 1));
>>>>=20
>>>>       if (!vmemmap_can_optimize(altmap, pgmap))
>>>>               return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_=
SIZE);
>>>>=20
>>>> -       if (order < PFN_SECTION_SHIFT)
>>>> +       if (order < PFN_SECTION_SHIFT) {
>>>> +               VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_c=
ompound));
>>>>               return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound=
;
>>>=20
>>> That makes sense as well, within a section, we expect that we always add=
/remove
>>> entire "compound"-managed chunks.
>>>=20
>>>> +       }
>>>> +
>>>> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))=
;
>>>=20
>>> And this is then for the case where a 1G page spans multiple sections, w=
here we
>>> expect to add/remove an entire section.
>>>=20
>>> So here, indeed the "min" makes sense. I guess we also assume:
>>>=20
>>>   VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>>=20
>> Yes. But this one we do not need to explicit it to
>> assert it since at the front of this function we have
>>=20
>> VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) !=3D pfn_to_section_nr(pfn + nr_pa=
ges - 1));
>=20
> Ah, yes. The alignment checks + VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTI=
ON);
> however imply that.
>=20
> So you could simplify by using that check instead of the pfn_to_section_nr=
() check.
>=20
> But it's still early here ... so whatever you prefer :)

Thanks for the suggestion. I think your approach is also
good =E2=80=94 at least it looks shorter and cleaner. I'll switch to
using VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION) instead.

Thanks.

>=20
> --
> Cheers,
>=20
> David

