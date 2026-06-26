Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9286BCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833186B00D7; Fri, 26 Jun 2026 00:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8095E6B00D8; Fri, 26 Jun 2026 00:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FD16B00D9; Fri, 26 Jun 2026 00:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7336B00D7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D20B01C185D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:17:01 +0000 (UTC)
X-FDA: 84920753442.10.66BE5D9
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0887920006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:16:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tU4auLan;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782447420;
	b=nriRv/rFGzC524GLOZ207wcfyY8QeYi2eRo3LOYbOr2WPfrM/zhh63W+4/sfD6Eamb1x5e
	v791MMRlNEgR8vhT8cIDXYonJzDM2EaRZ75+OQGhC805uWV423aqsbyMf4p+DVtRCqTST2
	4zTIArTJ5HlV3AJxfeAnhTs5ioYlOWg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782447420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOkT4HE4MTvk1wZ4w40cb5pP0zMW5GgLzCncJ/GrFKA=;
	b=u6KTXwvTvzYn3d8ZvNBmANiG9R+LYzwnnFXPFfAPZtVTTvtpKkS/1nAumkfS2+nP8uT9Cr
	pjnr/oDnQ6t3oF5YvKVfRJlZ5ZowiJtl/wcLtDkkRADf/Q8X2vVU4cqkjeaYbJ57cY1XhZ
	WbTLOXDU8pSR3x0p4Sp/sJAl35cLT/U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tU4auLan;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782447417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XOkT4HE4MTvk1wZ4w40cb5pP0zMW5GgLzCncJ/GrFKA=;
	b=tU4auLanIoznu++bAndccmy95kBQZM3vq3F5BJdIdB3bzdmwcKIzlcD38N7fNciBZ/LSMH
	FmoUliuhEWquBQUxpNJpE5YaDbsYyNkQL31Ss1/hRuoD6Ntulu0n0evwIVXfNH2VKUj639
	Q9BDEF4Ep3G7a4GsovfzVtNZszPAUak=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/5] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <4619650f-28b5-4fb4-91be-50daa0b4d84b@arm.com>
Date: Fri, 26 Jun 2026 12:16:16 +0800
Cc: riel@surriel.com,
 vbabka@kernel.org,
 harry@kernel.org,
 jannh@google.com,
 lance.yang@linux.dev,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com,
 apopple@nvidia.com,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 gourry@gourry.net,
 ying.huang@linux.alibaba.com,
 mel@csn.ul.ie,
 nao.horiguchi@gmail.com,
 ak@linux.intel.com,
 j-nomura@ce.jp.nec.com,
 pfalcato@suse.de,
 dave.hansen@intel.com,
 tglx@kernel.org,
 jpoimboe@kernel.org,
 ryan.roberts@arm.com,
 anshuman.khandual@arm.com,
 stable@vger.kernel.org,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 david@kernel.org,
 liam@infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF014590-F5F0-4B9A-9C6A-C4EAC8187237@linux.dev>
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-2-dev.jain@arm.com>
 <f8516534-3b18-4988-b384-251225755285@linux.dev>
 <4619650f-28b5-4fb4-91be-50daa0b4d84b@arm.com>
To: Dev Jain <dev.jain@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dkqi4xkx487cwirq9z33qtboh6cgmcri
X-Rspamd-Queue-Id: 0887920006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782447419-556784
X-HE-Meta: U2FsdGVkX18RtinAtEuef3oy14vMNTIfb/C/W3we440NzjIUBy6cVo8HeSTqsEBr3OxLn3TnlsISwUoi9/7lya9OrbcJfwCzms8FqjZ/hE/K9cGpedW+6AF1fP0xZIMPDAS99lcVRw1g0U1o+6zQc1u9/e64D57w7VfhasDMyErlF2FcoxPnUMEQlGLiIOqmu6kxSRJM9KBsti22hsiYlXbPVu/WlH2VB0kYediThhZEKQ1KCSeU5TdXCj4+664tB6D1q6GSDb30A4d9lPKZlcZNBM29wTYCozR6G3NHXWwIKv0bJmvuFtM2dRIuIEaAUspHebSJDUDTCJbzQ2tc4GbVqPy6Z+RoxSFN3koBVPf/hhdusT7F4E19EaK1nBRcFiRX6W4uIlrWTtqEbPF9fVDXl+t77rqjsWZpDceGd41S+y3IvFWvmDzKMKlpCv68aSh9egmH4MF+1rlN6E66sAUcSRc0ZebWVfgYDgbtgLg1Oi8lBWWvb48PZfiKgbEfsoVDpvHN7pKDV8E4z5mWSmdZL8tLVhm46wFhCeovx2Z0nS+EyQABSydF+BLEIZT7B6vcHmH/yGwDXj243j6zaBKwlX+A2ekTW5R3JeO3xdxa1NDEYjElaHhB0qkODeJHohZBn4Ts6auAoZoRs13alytuEK0uMsSZfwQzon6D6OOkRsiY/l7Xi7drVExVhr23S3LxdjEdAXbOQiVXTchojoFhF+z4NoLNro8aTXMRxOHGBziOUmrt9n7FWuCay+sOXFMvlZEAY8wSKpAyr9mRogEhrRS+ccmX4mKvtb8LqgWaUKn+k0XAgmWjVQdRwrlhjKAh5Hqgn+TYJdx6S2izyS1Mlhyyfj9KWsDkR89jQKWqJQeko2+uJ5u2vWPgSoyPJSFUaKgMsMVF4SDtTECCVXY8UT+Q+0gnJXhgLGPfexOrPARH1u4rW97YZCojzVivJ05i8phYWaFQkAqptiJ
 QvlDkapl
 DD+3G4Wj5dctvtUwWWXfHxsueFLN6XhUterwuAht9OSrKX8qyIIzzO3ohwLTF7okaEyNLER/M0Z5cRbhFmd213tsZHPbb8/89x7mfMg5+L0ndg+4yhld1b/zuyUNV+MgID/Q5a7lS9RE04cmLaUN5oYVzXG8jwVqC63vrYJrZb0DJw69HY5c6lzai2uDgSeFBYFpObEa9lZ/xhPlqIIzk89doqh/2Rf9lF9UiWUAIBQ5LIaqaGkMwCh+Q7xsedl5PkHNfs8kTZW5F3eg2anQKa/WzD+/I1sk6C36WcP3sdvL2RSo1zg7lNXy2edTst7neCVopOl6omfET94Aia0Hw81lE0BhqPQMj3i0ZZ0dd2TMTav9+cdLY3/X3Tf+nD7r6gfWkv0p6IidCYk0In39HfiDLKIw2JKb5jWbOQ+8OV4ZIYA+vmsLyGgJ3UlnTcQxFuR3j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 26, 2026, at 12:03, Dev Jain <dev.jain@arm.com> wrote:
>=20
>=20
>=20
> On 26/06/26 8:47 am, Muchun Song wrote:
>>=20
>>=20
>> On 2026/6/25 19:29, Dev Jain wrote:
>>> try_to_unmap_one() handles hugetlb folios when memory failure needs
>>> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
>>> case page_vma_mapped_walk() returns the pte pointer to the hugetlb =
folio
>>> in pvmw.pte, but the code reads it with ptep_get().
>>>=20
>>> On arches which provide their own huge_ptep_get() to dereference a =
huge
>>> pte pointer, accessing via ptep_get() would cause pte_pfn(), =
pte_present()
>>> etc to misbehave.
>>>=20
>>> It is not clear whether this has a trivially visible effect to =
userspace.
>>>=20
>>> Just use huge_ptep_get() for dereferencing a huge pte pointer.
>>>=20
>>> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use =
page_vma_mapped_walk()")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>   include/linux/hugetlb.h |  3 +++
>>>   mm/rmap.c               | 16 ++++++++++------
>>>   2 files changed, 13 insertions(+), 6 deletions(-)
>>>=20
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index 2abaf99321e90..fdb7bdf7645c5 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -1261,6 +1261,9 @@ static inline void hugetlb_count_sub(long l, =
struct mm_struct *mm)
>>>   {
>>>   }
>>>   +pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
>>> +            pte_t *ptep);
>>=20
>> Thanks so much for the fix! I'm curious, though: why do we
>> need to add a separate declaration for this function here?
>=20
> For !CONFIG_HUGETLB_PAGE, compiler complains that there is no =
huge_ptep_get.
> So this is to make compiler happy.

Got it. We can refer to 5d4af6195c87c6b162b7963e0ad00a214b80d764 to fix
this warning.

Muchun,
Thanks.

>=20
>>=20
>> Thanks,
>> Muchun
>>=20
>>> +
>>>   static inline pte_t huge_ptep_clear_flush(struct vm_area_struct =
*vma,
>>>                         unsigned long addr, pte_t *ptep)
>>>   {
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 1c77d5dc06e9f..aa8a254efaecc 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio =
*folio, struct vm_area_struct *vma,
>>>           /* Unexpected PMD-mapped THP? */
>>>           VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>>>   -        /*
>>> -         * Handle PFN swap PTEs, such as device-exclusive ones, =
that
>>> -         * actually map pages.
>>> -         */
>>> -        pteval =3D ptep_get(pvmw.pte);
>>> +        address =3D pvmw.address;
>>> +        if (folio_test_hugetlb(folio)) {
>>> +            pteval =3D huge_ptep_get(mm, address, pvmw.pte);
>>> +        } else {
>>> +            /*
>>> +             * Handle PFN swap PTEs, such as device-exclusive ones,
>>> +             * that actually map pages.
>>> +             */
>>> +            pteval =3D ptep_get(pvmw.pte);
>>> +        }
>>>           if (likely(pte_present(pteval))) {
>>>               pfn =3D pte_pfn(pteval);
>>>           } else {
>>> @@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio =
*folio, struct vm_area_struct *vma,
>>>           }
>>>             subpage =3D folio_page(folio, pfn - folio_pfn(folio));
>>> -        address =3D pvmw.address;
>>>           anon_exclusive =3D folio_test_anon(folio) &&
>>>                    PageAnonExclusive(subpage);



