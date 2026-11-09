Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89124606D812
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ZBhZOro/
Received: by kanga.kvack.org (Postfix)
	id 29F3D6B05B1; Mon,  9 Nov 2026 04:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252B56B05B2; Mon,  9 Nov 2026 04:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165EB6B05B3; Mon,  9 Nov 2026 04:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20096B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:22:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50B43A823E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:22:51 +0000 (UTC)
X-FDA: 85415040942.03.AD3186A
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6651E180004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:22:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="ZBhZOro/";
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794216169;
	b=enM7Xig8FQiDaPzy9HGiFmlcg90BTfO+NP5lc58NwqZ8IQLZSKzcVqmmjPdFzvjm8kx8rg
	Www/NymLgeks1nl9zvt4yuPr7Cjvq/fK4ytaVgGEh0HDbDTFXj43+7m6vM2ZgHu9fJicBo
	bgKM6LZxJJcABZegYPYW6ryDZFnkutU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="ZBhZOro/";
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNnB213C2cP0gdxYuL/Mc+HzLUB0/mR4NaAsZTbzJJI=;
	b=oZSjxX5B49yxQ+HH3Wlufb68QcFiQa1hqMdE62btppnZHp7oBZbuXgzxgyLscHw2+KQnJV
	8Nm648w6W+3YeSXG5i41p3E76A65miyyFNFcx+SrTutz2F6jESg+92dSN19m7WBpWljLSZ
	+qu1hI/xBup4RapjGXnYxgEM9ezH7jE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794216163; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=FNnB213C2cP0gdxYuL/Mc+HzLUB0/mR4NaAsZTbzJJI=;
 b=ZBhZOro//66cOhz/DkdekwbBVWx6A1ys7GBryWKo1VycRSJqGMyWY+rtSRvsXwDu6AIYH8
 Ldb6x6vjx2AbCnRJRFOnAvs+xOYVYgNaWDassu6Vt4GbPniDkkbwS/ONYGx4YsvGCXFps/
 yX4ZuH6gOe+bYU5AZ9BkiR3X3dOhC88Gsv7OaKvl2E6vvSrmjiHYCX5zNst31gp/PDDjF/
 zhvheQKP8Rl3bj7Gds/Tm39jKSa+DUQevrg7IRPaF/BQuc7eXR1evyqFrDWggHeLdoRzZN
 7vpE2Id61PdUD35yx1/n6NrNEeaY9O7UGzSERXNqmf7Ujmvbks0PnEVdpIeE2A==
References: <20261105120615.16817-1-lizhe.67@bytedance.com> <20261105120615.16817-3-lizhe.67@bytedance.com> <au2qhlsxQt3SRwIu@parvat> <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com>
In-Reply-To: <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Date: Mon, 9 Nov 2026 17:22:24 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26af190e1+9d582e+kvack.org+lizhe.67@bytedance.com>
To: "Balbir Singh" <balbirs@nvidia.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <apopple@nvidia.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Message-Id: <3e5a9f27-ea35-4557-95d1-70ce359e4c92@bytedance.com>
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
X-Stat-Signature: 1hw7haeunbginb433aqcspnxn6zabdrz
X-Rspamd-Queue-Id: 6651E180004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794216168-779931
X-HE-Meta: U2FsdGVkX1/wYgEa0znJMr82nDZwcQNZz39TY50wM1sqUeeQ9+S1ubUAaIwzyVtvFNHgmEeiUEqVzP0CNxNTXVJDFsr7Y5CRTAc7G/66KBWsmYn6+7XjE4mZyulocITwOMfbwEeZeXl9L4Ka1+aUhKtmy6GrazDof+FhQwbpRC7qATbohY2XkTyVzLqUFsQhEYF0LkY2dcLzbdiZcAELSZp1pijWUtRlSCu7bTLAblhZ5SDOn9iW8/b+AyZe9ESn4Z4HCDe8OI1Ey1z4TJScLwfB9u4wkaIiXSLMW1+uUjMRChfNHEWhThX1Vu6tTBjmoNZqf5+SLZBENo3iOrExk4mRGCprPvWL4kuR6W6ghstntA64f4xqcU7CQeEOJs27TgKC70KRb8FwP222IxlP/JTD74Y9fqaht06eneoA99cP6874rjogX3k3ZRFOYemFUgeH7IYRQjmq5hEvSCwmb7Tp0GXeWl8GBYlAaS3tyvaglIdEotEoSNRShRMHIDlERLtAPzgzqCMDH4retIkFl6ULulmZXwZ0zzRGZDXZg7W+7cTez7ea0NKJ5TLqI+m7cipKMg/pgoKM3nXLSGVpWUePheyRBaT/KJTjHaZFMJALV5Lr8WtPIWGQco5XNPkNlmQQtTgIImPVsEl1xKuyhyY0xp4GFqfYASTYQhmBV3QdN+tabw3Gpt3DN8z6JvSTpfo+iQKS527NgereSi/iMb8MCeFUiqTBkALIV2qGxRs/ObGeiR4GCAZjQuVN5sZ7UbAyVNmFkXS5YO65QOA7tM8ihU4461gSNxZBRF1tfnayoYzGkTz/kt9jRUarMfjqGeUGEECkBr+MC2mpqSGi8nH5jMPWJ6kacj9J1aQrFcn2Vc97PdXZ+tQRMSPFfnVXrALEFQAih/QUm7+ZI4Mdrp4qHaJgsPrhcpG6PnRAvVyAk+bPC8ofkWCGarxFI05erL1E42Wn4RA/bVRyYRF
 wXlC95fb
 DNhWdB6Y91nWbqtXl+5ADxWG5tVjEl0pthKRJJcqehCAa/99EddVtPZPARY1eVROCu/SKCwkWwethaKAY6L0xLjNWes6zFBwhmEb2/sv82jGzvexaLAM/1q/QMhUP9ZiPz9E+49s6nL+jq5IkyoDwfjtlVj2iguP00znzBq0/r63IXGnR+vVVT4ywm6gGNlABqQqFxfUXZGYw2MKj/ZfEbX7gSfez/cL0Kw8gY5C1e5GMe6EAxk9NzxO8st3Fc47zQ0kFdcJIA6wNScbtGXIGbUC/ASW2QjUsoi9kAmcINXoq5kSZAHyARBUfbLgJJPG88RDY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 11:01 AM, Li Zhe wrote:
>
> On 11/6/26 6:23 PM, Balbir Singh wrote:
>> On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
>>> Boot-time HugeTLB allocation has to initialize tail struct pages itself
>>> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.=C2=A0 =
For
>>> gigantic pages, this can cover a large number of tail pages. Most state
>>> installed by __init_single_page() and prep_compound_tail() is identical
>>> for every tail page in the same huge page; only PFN-dependent fields
>>> need refreshing.
>>>
>>> Initialize the first tail page normally, copy it into a local template,
>>> then initialize the remaining tails from that template with
>>> memmap_init_page_from_template().=C2=A0 This avoids repeatedly doing th=
e=20
>>> full
>>> __init_single_page() and prep_compound_tail() sequence for state=20
>>> that is
>>> identical across tail pages in the same huge page.
>>>
>>> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
>>> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
>>> initialization time improved by 36.43%, measured with a temporary
>>> jiffies-based printk modeled after the existing timing in
>>> memmap_init_zone_device():
>>>
>>> =C2=A0=C2=A0 base:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 318.4 ms
>>> =C2=A0=C2=A0 with this patch:=C2=A0 202.4 ms
>>>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>> =C2=A0 mm/hugetlb.c | 23 ++++++++++++++++++-----
>>> =C2=A0 1 file changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index da5d04edf7c1..987f16a5ea27 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -3219,19 +3219,32 @@ static void __init=20
>>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum zone_type zone =3D folio_zonenum(fo=
lio);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nid =3D folio_nid(folio);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page =3D folio_page(folio, =
start_page_number);
>>> +=C2=A0=C2=A0=C2=A0 struct page template;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long head_pfn =3D folio_pfn(fol=
io);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, end_pfn =3D head_pfn =
+ end_page_number;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order =3D huge_page_order(h=
);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 if (start_page_number >=3D end_page_number)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> +
>> Can this actually happen?
>
>
> No, current callers always pass a non-empty range. I kept this to
> preserve the old for-loop no-op semantics for an empty range, but it is
> not needed here. I will remove it in v2.


I need to correct this. A local Sashiko run pointed out that the bootmem
fallback caller can pass an empty range on SuperH.

SuperH supports a 64M HugeTLB page size, and with 64K base pages
pages_per_huge_page(h) is 1024. HUGETLB_VMEMMAP_RESERVE_PAGES is
PAGE_SIZE / sizeof(struct page), which can also be 1024 or larger on a
32-bit SuperH configuration.

In that case the old for loop is a no-op. So I will keep the empty-range
check in v2, before creating the seed template.

Thanks,
Zhe

>
>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * As we marked all tail pages with=
=20
>>> memblock_reserved_mark_noinit(),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * we must initialize them ourselve=
s here.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 for (pfn =3D head_pfn + start_page_number; pfn < en=
d_pfn; page++,=20
>>> pfn++) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __init_single_page(page, pf=
n, zone, nid);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prep_compound_tail(page, &f=
olio->page, order);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_count(page, 0);
>>> -=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 pfn =3D head_pfn + start_page_number;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Seed a template from the first real tail pa=
ge and refresh only
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * PFN-dependent fields before copying it.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 __init_single_page(page, pfn, zone, nid);
>>> +=C2=A0=C2=A0=C2=A0 prep_compound_tail(page, &folio->page, order);
>>> +=C2=A0=C2=A0=C2=A0 set_page_count(page, 0);
>>> +=C2=A0=C2=A0=C2=A0 memcpy(&template, page, sizeof(template));
>> Do we need a separate template and page?
> Yes. page is the first tail page that has already been initialized
> normally. A separate template is needed so that later iterations can
> refresh the PFN-dependent fields before memcpy_nontemporal() copies the
> final state to each destination page.
>
> Thanks for the review and the Ack.
>
> Thanks,
> Zhe
>
>>
>>> +
>>> +=C2=A0=C2=A0=C2=A0 for (pfn++; pfn < end_pfn; pfn++)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memmap_init_page_from_templ=
ate(pfn_to_page(pfn), pfn, zone,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 &template);
>>> =C2=A0 }
>>> =C2=A0 =C2=A0 static void __init hugetlb_folio_init_vmemmap(struct foli=
o *folio,
>> Acked-by: Balbir Singh <balbirs@nvidia.com>

