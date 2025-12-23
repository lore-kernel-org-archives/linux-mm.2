Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C8AE6F06C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 08:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F396B0005; Tue, 23 Dec 2025 03:38:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D556B0089; Tue, 23 Dec 2025 03:38:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159CD6B008A; Tue, 23 Dec 2025 03:38:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 011E86B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:38:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97378C05C0
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:38:15 +0000 (UTC)
X-FDA: 84250083750.24.520DFD7
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id B76A3A0019
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:38:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SIkXFXx3;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766479094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3bZGvz6MmLv1ELl8PtfKAdNX1JyM/84K1naNpWvlzU=;
	b=Ia1LSHqPPXz1LhSIq+neAdqhTxPdXDQSfL93Gf2CfVHCWOF3O0gdA05HFytkn9mv0a9siN
	nFbPB/s4JatYlBCvagh7Mi2audMT8mX/vhxOct9NQETFfFZdkJgifaA/XLeUNC+b5mo8u2
	vGTMfToBPKEuB74pVlUBDsSF5fynqJE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SIkXFXx3;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766479094; a=rsa-sha256;
	cv=none;
	b=OTJdwo9rPEDfTQwxzZpTQb2kEvHDRoNTvaTZUuQmBY0n2vabMMBLNU5uGoJ9iBNxWez0Iv
	viyOiLLdq8jZjuBv5thLnoGIFzCFdnd7+s33Ib/Ux4obau19ZE4U7ybMAcVL4bmoVG29oM
	kwJHkSj4a9asxQiXTrrvCbQtj+G1WcY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766479091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3bZGvz6MmLv1ELl8PtfKAdNX1JyM/84K1naNpWvlzU=;
	b=SIkXFXx3A5OBSvwycBg77SCgntOdSO/3JTaPBParteu7KlOITT/9m2GUiC/30qBIR5HSGX
	cCjlmpvNz6WPbA1GRMOLZ9HcL6Mqge7p46ZYQbYdjnoUa/UeiKxEJ1cwOKikH1wqhFqrP7
	bsExehCgQ3NK9OI0FeqbbIGM4gfXue8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 06/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <jre3fk4ojcw4qbnp2feq7ed4iwo4zjj5leehv6l6jtw6soigm2@iybzeqz7jyi7>
Date: Tue, 23 Dec 2025 16:37:39 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1786115E-4C04-490B-A45B-9C06D7B33ED3@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-7-kas@kernel.org>
 <bde227ef-b072-4f48-ab68-bf184dfe7421@linux.dev>
 <jre3fk4ojcw4qbnp2feq7ed4iwo4zjj5leehv6l6jtw6soigm2@iybzeqz7jyi7>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e518nanrtynfenk5ooc5amhr5fdg9y9k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B76A3A0019
X-HE-Tag: 1766479093-828187
X-HE-Meta: U2FsdGVkX19k4aN4a/A2PvTWLgwO7ta6iQZyqtm7eyuLmgzLGwcBJnuJ3NRB+wVw8uYlK/4SOTG8FcNobAkx/tNIaSDHIkCh2SgsSIUOl1L2FM9Euxj94/21xYpuJOITFxWF4pjMUeVOlGdEsZVZg2XBm7tJ0u/jUxJjZBaM4Mn7i0d94gSIoxqdYmedC5ojot3cFCcnM2J0p3zeD+Vpj/7xkT2yIXpVOdUHuZTScQwUDE3ziKaFLmpyhOtUcHSojOqAPPjldXYYx4yldsn3tNikMkl4/WROEwFAYmE5AVYNSacOowTZr7DmfJfLHOAbE4qvjkaTsFw9MgfJpqyd9H1zlK8rtwyirinrKJDonOyEaouRTcDSC4OIvdqStFC0S7bvYrDGljZ2CT/jRJAhVoEFRX4fWPiUJ6YnNmxH+Yf5cXiI1qibC57qJc/JC1vnyNtL37XCe8XvzMxTBQ9LwCQ+eFnLmrkkmYJ6t4IiEgAmCG3x91CSu+JXqNlVlUCVdnf3x5O/qVatT80q3HvcEmU0uZQKM9QsAm8t+aLUKpqhIOiNXhOa8+WBQ5wCSuOLluzxjWwSWmZ7IcZGxhK+OEmw2UJWUI/VgdrQRDnbxqGndnjkC6kbPHsr76gBKRXZ8fA/D6w04nRYUmGBjzEAXKqREXpEEJtcz3nyMovzqy4HbY5A00q+TnzOALZ4L5U/5Z93SnQ5jRtD4idSWttsG5oHbn2oD2N2ZSFqjlQFpxQHL1td7lArAiVQvNzggKUh1ZwNKuxCIrEtj9KS+YpcsIxPHtLypjE8JFNiON9NCHFfz+5FgSZi47q+9BHCsyM4NGjn5vWLZt6UL583qQEOmJxYaodS32VN2qg9TznI4GU4Sg7sefN3YsqVHBsSC64UBAYelnGRDDV9R7us5dNW8tS4aXDMIOTYf3pMeyfqQ+fX7DWTOHlky39yxXf+xJakRzF62NgOwlArQNnMq3u
 ii9ZQhj+
 6g7uyXVSOEnVfVf1wXyWfTVjAOMLO5JIV1Utl8ZxB7mqj0d+27wVNRKirnVPDFmYx5884hQ9PAxCrgjkjau+AK5wgUOUx+3xZzJQobQa5tEAows0EcvTj7bnReoCvrglHcnvGdULal6v9ncafDC7uKa5pfXz8LAB0GNeH2NnN5kh3Hb+ReW/jVg7Rv+tbk1sZR5UNumUUGoFcj0JLV7GMRwTXqdqTecU0b9+eKs958Xml8t5CgcnuVYO7egxx8b9t6peTIFoBa0aYbqQCnZ5ZXCSXEpN65yiSPFplYbydQZUb8A2NxIjT/0buxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 22, 2025, at 22:03, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Mon, Dec 22, 2025 at 11:20:48AM +0800, Muchun Song wrote:
>>=20
>>=20
>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>> For tail pages, the kernel uses the 'compound_info' field to get to =
the
>>> head page. The bit 0 of the field indicates whether the page is a
>>> tail page, and if set, the remaining bits represent a pointer to the
>>> head page.
>>>=20
>>> For cases when size of struct page is power-of-2, change the =
encoding of
>>> compound_info to store a mask that can be applied to the virtual =
address
>>> of the tail page in order to access the head page. It is possible
>>> because struct page of the head page is naturally aligned with =
regards
>>> to order of the page.
>>>=20
>>> The significant impact of this modification is that all tail pages =
of
>>> the same order will now have identical 'compound_info', regardless =
of
>>> the compound page they are associated with. This paves the way for
>>> eliminating fake heads.
>>>=20
>>> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is =
only
>>> applied when the sizeof(struct page) is power-of-2. Having identical
>>> tail pages allows the same page to be mapped into the vmemmap of all
>>> pages, maintaining memory savings without fake heads.
>>>=20
>>> If sizeof(struct page) is not power-of-2, there is no functional
>>> changes.
>>>=20
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>=20
>> Reviewed-by: Muchun Song <muchun.song@linux.dev>
>>=20
>> One nit bellow.
>>=20
>>> ---
>>>  include/linux/page-flags.h | 62 =
+++++++++++++++++++++++++++++++++-----
>>>  mm/util.c                  | 16 +++++++---
>>>  2 files changed, 66 insertions(+), 12 deletions(-)
>>>=20
>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>> index 0de7db7efb00..fac5f41b3b27 100644
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -210,6 +210,13 @@ static __always_inline const struct page =
*page_fixed_fake_head(const struct page
>>>   if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
>>>   return page;
>>> + /*
>>> +  * Fake heads only exists if size of struct page is power-of-2.
>>> +  * See hugetlb_vmemmap_optimizable_size().
>>> +  */
>>> + if (!is_power_of_2(sizeof(struct page)))
>>> + return page;
>>> +
>>>   /*
>>>    * Only addresses aligned with PAGE_SIZE of struct page may be =
fake head
>>>    * struct page. The alignment check aims to avoid access the =
fields (
>>> @@ -223,10 +230,14 @@ static __always_inline const struct page =
*page_fixed_fake_head(const struct page
>>>    * because the @page is a compound page composed with at least
>>>    * two contiguous pages.
>>>    */
>>> - unsigned long head =3D READ_ONCE(page[1].compound_info);
>>> + unsigned long info =3D READ_ONCE(page[1].compound_info);
>>> - if (likely(head & 1))
>>> - return (const struct page *)(head - 1);
>>> + /* See set_compound_head() */
>>> + if (likely(info & 1)) {
>>> + unsigned long p =3D (unsigned long)page;
>>> +
>>> + return (const struct page *)(p & info);
>>> + }
>>>   }
>>>   return page;
>>>  }
>>> @@ -281,11 +292,27 @@ static __always_inline int =
page_is_fake_head(const struct page *page)
>>>  static __always_inline unsigned long _compound_head(const struct =
page *page)
>>>  {
>>> - unsigned long head =3D READ_ONCE(page->compound_info);
>>> + unsigned long info =3D READ_ONCE(page->compound_info);
>>> - if (unlikely(head & 1))
>>> - return head - 1;
>>> - return (unsigned long)page_fixed_fake_head(page);
>>> + /* Bit 0 encodes PageTail() */
>>> + if (!(info & 1))
>>> + return (unsigned long)page_fixed_fake_head(page);
>>> +
>>> + /*
>>> +  * If the size of struct page is not power-of-2, the rest of
>>> +  * compound_info is the pointer to the head page.
>>> +  */
>>> + if (!is_power_of_2(sizeof(struct page)))
>>> + return info - 1;
>>> +
>>> + /*
>>> +  * If the size of struct page is power-of-2 the rest of the info
>>> +  * encodes the mask that converts the address of the tail page to
>>> +  * the head page.
>>> +  *
>>> +  * No need to clear bit 0 in the mask as 'page' always has it =
clear.
>>> +  */
>>> + return (unsigned long)page & info;
>>>  }
>>>  #define compound_head(page) ((typeof(page))_compound_head(page))
>>> @@ -294,7 +321,26 @@ static __always_inline void =
set_compound_head(struct page *page,
>>>         const struct page *head,
>>>         unsigned int order)
>>>  {
>>> - WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
>>> + unsigned int shift;
>>> + unsigned long mask;
>>> +
>>> + if (!is_power_of_2(sizeof(struct page))) {
>>> + WRITE_ONCE(page->compound_info, (unsigned long)head | 1);
>>> + return;
>>> + }
>>> +
>>> + /*
>>> +  * If the size of struct page is power-of-2, bits [shift:0] of the
>>> +  * virtual address of compound head are zero.
>>> +  *
>>> +  * Calculate mask that can be applied to the virtual address of
>>> +  * the tail page to get address of the head page.
>>> +  */
>>> + shift =3D order + order_base_2(sizeof(struct page));
>>=20
>> We already have a macro for order_base_2(sizeof(struct page)),
>> that is STRUCT_PAGE_MAX_SHIFT.
>=20
> I used it before, but the name is obscure and opencoded version is
> easier to follow in my view.

OK. I'm fine with opencoded version as well.

>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



