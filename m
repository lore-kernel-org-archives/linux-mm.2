Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF49C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9086B0098; Thu, 17 Sep 2026 23:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2B76B0099; Thu, 17 Sep 2026 23:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB96B6B009B; Thu, 17 Sep 2026 23:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD986B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:13:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8ACAA5E07
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:13:26 +0000 (UTC)
X-FDA: 85225412412.03.FA9A8E7
Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2360A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:13:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OLnHFwLu;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789701205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yASsbAmWEq02nXdhFVYJ4UF8/LDCvkp8q6cA/4ikZk=;
	b=lMyzt8VfWtL+HY5L5w/tZ0gIEnWdKfvU7f4BAMi/NnU+CROVnY0fsevkMxdh59ZVjeiyq6
	gk+wOq6SD6brk2/AQK1AhCIVmVv0/VSKzWBOHpxdBlhZ4A0B0qxYOeEB17GS1phjunDHaF
	T4I2QZm1DlHnB9xJYUhZKZ4GFBG9ESc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789701205;
	b=YirvK5CfJi0rTEDqtenzdMUsyN/Ca4yTgIAxI0JsWmbnNkPRGZKGPUPnMrqXRa9IzkZ93J
	4lycNEv8dXSIJfbGqZECpUnIyKti1oZDqEe5epc4+KHj+Z+8Xw3rFOv6d3iivRilhH9Ht8
	vDD3n0aE1RPIun4dOlH90DapE7nD2L4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OLnHFwLu;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rkn/RIiY9BjLJ/8Nz1FlDN7V2RpqMaZCBysWzgkBWaA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789701203; v=1; x=1790306003;
 b=OLnHFwLugetQqXu7J6UCm/JMKkjBzNriZGlObH/A7g6gLfogF4p0jKGTEtt52x9aq3ESeFO1
 zH/sQjJkIe6tBswucnba96dj4pFRJaO5ev8Kmi7otbsaSIXaf0OgNWcVkaZIX9rDypqt5BbkPVK
 SxhLWYnCOykiiJI1ocBdzSiA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 56057d78e329f5f0;
	Fri, 18 Sep 2026 03:13:23 +0000
X-Mizu-Trace-ID: 56057d78e329f5f0
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v4 05/16] mm/hugetlb: use direct assignment instead of
 folio_change_private()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <DLI26G4YSWIO.E52DKMAH6ZSG@nvidia.com>
Date: Fri, 18 Sep 2026 11:13:05 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A1A14368-7A43-40ED-B2AB-C2EC2C5FFB1D@linux.dev>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
 <CC279633-6F0F-440C-BCDF-1D5362C4CB7B@nvidia.com>
 <c7a5ff0c-126d-4762-8b04-5897da09b8b1@kernel.org>
 <DLI26G4YSWIO.E52DKMAH6ZSG@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2360A0002
X-Stat-Signature: ddhcwopidg5bn1754jkpdwmsm7g7e6sm
X-Rspam-User: 
X-HE-Tag: 1789701204-414797
X-HE-Meta: U2FsdGVkX18z6jD1/vkqcX2b2fCVxtWbmkkoRm5rkaUQjOGGE5VnH/ymoVgpwIAWrHUDHKtbaV8aE4AJNrJwuJTrOCXEYPN3FPDdLb+tldIDnYkoUusTnMd5JwBbBE8tOvQOXMvoDDfP3YvdLb38DgCe4zrCDwbyjFDw/mhI+R8TrHHPq6reQSigraqaz6IgXQ8dWRgjnjIQU+ImxgaC6T2JBn0ZqhnIvJ+Gq3C+wPj+mzxVdatcTnnc/UF9KB1+lz2tJXaxdD0qwx89d6LzagIjirSe1E54iN1TUvPKtH0VDBcmG66KTpoYfcdPVDar56mBhrQb0fcwcjLxt/VMqBg3kQVWiBwizxfUOmZ6T0UDbQkERo4fN4Xi5XBBmry5kljYa24NLvpjJfequtRgOGG4CQ1b1KQuWofeTjASqPLPyzY+QjViNBI/y3KZs297tngap1kP3x43ONRcFQAzuEJDx0LMKkfRmaMQ90DA9I6Q/N8E/0XLc3WqlZcdAHP5XaZVvuPEI6PfjXbsE+5Pn/nhDm864oMVK0hvoK7XP73iBRN4E+nyB9cGIw4YZmMHidLk3kQcT8hUoD+3Cldz1Hi80R2DoxvGsyCQE2YAjCkjvHYQplcmGAO6OBTTFavD3iWxRQkqSj7Xe2T4tSyNdn7Pb2EC6FieJRS/x2PLMEgZlx+k9lw1LfnrINaPygT/Hx8x8JMzfvaS6pNecSm4JYoeVc9z1XtEAZxeQGAfXt3MGBR356Yz2wcxvRTmK9fd8+npsjmkoTpJT01S8B0KluXM9mbd4VUXm1OnsxhYSSuRp/kwmlOzr3ipcDn/Md7WXFzaLMmIIxHidhGG0EBP7ZUds1g/+bDiXJXS+PFwJd/1UjTzvjEH5Cqv97IHFWHnmNH/QJH4kYGGB4chuKhkLiYnR1T+bgdtQU8mDGUvmetdO65HnRDY0pQ1Szxt67QJJpIn/f7J53fKGEPA8lN
 3WqWZNeL
 JUkaJo/rHubeFh7zr+dztWk0gQlSwzRbD/5MW33H3Gm4ItIUsC2ffqNktgeVtZWSY/su+rRNt0sdzp9LxksaRanxweffVD7SFeix4i0QWWN4Y6Dp9bWqS/0QLoQlhitHEjIJ3dtUCQzrX4j5JrU/qWTpL6867mJqH7LcPZkotx0ngKDmNDK1KJMzMe1SVme2AFYaNa+AoK2n9TNHAKhDuWLvXuxsmbKpC02keG8e4qOhwMjovMHmp2LUh7Ttvbwxi5AxAf4MQ0WSZfWbXoBCeaUUhjayUT956k0hM4viguopnby0aqHba03Xsp0tPnVFki4CLi2lepEeUcYqaN7cDIdKI1NdHmHTWgW9sh7upPV8Fc9xgztaDoqdUsQg4L/HEi16JF2MOlrFOBedBZzrOL18O5iJ0HTZ6Uo4HMH+eg4gPNRNuW6CStfiy0iViuYSlrg/ya9svs+c+i75w9JxCmCvMgW6WVXDHsh4/mpFQQVuE9cadndyDzCTgxd8C7iYP2TLQxtkGJkxbfmJxb0tVHD7VmAvv/5LX97hH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 18, 2026, at 09:41, Zi Yan <ziy@nvidia.com> wrote:
>=20
> On Wed Sep 16, 2026 at 2:12 AM EDT, David Hildenbrand (Arm) wrote:
>> On 9/16/26 03:56, Zi Yan wrote:
>>> On 13 Sep 2026, at 22:24, Zi Yan wrote:
>>>=20
>>>> folio_change_private() should be used along with =
folio_attach_private() and
>>>> folio_detach_private(), where adding and remove ->private content =
requires
>>>> folio refcount change. add_hugetlb_folio() simply sets =
folio->private to
>>>> NULL without refcount manipulation. Change it to direct assignment =
to avoid
>>>> semantic confusion.
>>>>=20
>>>> It prepares for a future commit that remove PG_private.
>>>>=20
>>>> No functional change intended.
>>>>=20
>>>> Assisted-by: LLM
>>>> To: Muchun Song <muchun.song@linux.dev>
>>>> To: Oscar Salvador <osalvador@suse.de>
>>>> To: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@kernel.org>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>> mm/hugetlb.c | 7 ++-----
>>>> 1 file changed, 2 insertions(+), 5 deletions(-)
>>>>=20
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index d3a0650ff6905..8d551cdaef9db 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h, =
struct folio *folio,
>>>> }
>>>>=20
>>>> __folio_set_hugetlb(folio);
>>>> - folio_change_private(folio, NULL);
>>>> - /*
>>>> -  * We have to set hugetlb_vmemmap_optimized again as above
>>>> -  * folio_change_private(folio, NULL) cleared it.
>>>> -  */
>>>> + /* Clear all folio->private flags except =
hugetlb_vmemmap_optimized. */
>>>> + folio->private =3D NULL;
>>>> folio_set_hugetlb_vmemmap_optimized(folio);
>>>>=20
>>>=20
>>> Sashiko[1] said when a CMA hugetlb folio is freed but fails vmemmap =
restore,
>>> add_hugetlb_folio() clears HPG_cma. It either bypasses
>>> hugetlb_cma_free_frozen_folio() due to the missing HPG_cma flag, or
>>> skips cma_release() and causes a CMA memory leak if it is free =
directly
>>> to buddy allocator. Sashiko also asked if HPG_temporary should be =
preserved
>>> as well HPG_cma.
>>>=20
>>> Answer:
>>>=20
>>> Missing HPG_cma is a real issue. It can be fixed by checking
>>> folio_test_hugetlb_cma(folio) at the beginning of =
add_hugetlb_folio() and
>>> setting HPG_cma after folio->private is assigned to NULL.
>>=20
>>=20
>> Maybe we should just simply only clear flags we actually want to =
clear ...
>=20
> And it turns out to be a clean result (see below). add_hugetlb_folio()
> adds a hugetlb folio back to freelist, so prior operations like
> remove_hugetlb_folio() should clear hugetlb flags, like HPG_freed,
> HPG_restore_reserve, HPG_migratible. HPG_temporary is only set in
> one callsite in free_huge_folio() and is cleared before the folio is
> passed to add_hugetlb_folio() via update_and_free_hugetlb_folio().
> HPG_raw_hwp_unreliable probably can stay, since it preserves poison
> information. The remaining HPG_cma and HPG_vmemmap_optimized are the =
two
> we want to preserve.
>=20
> Muchun, maybe you can chime in about the patch below. It can be a
> follow-up patch after this series.
>=20
> Thanks.
>=20
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8d551cdaef9db..bc772954e5685 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1446,9 +1446,6 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
> }
>=20
> 	__folio_set_hugetlb(folio);
> - 	/* Clear all folio->private flags except =
hugetlb_vmemmap_optimized. */
> - 	folio->private =3D NULL;
> - 	folio_set_hugetlb_vmemmap_optimized(folio);

This looks good to me. Since add_hugetlb_folio() will no longer clear
folio->private, would it be worth adding a whitelist-based
VM_WARN_ON_ONCE_FOLIO() here to catch unexpected flags? This would =
document
which flags may survive the transition and help detect future callers =
that
fail to clear transient state before returning a folio to the pool.

Thanks.

>=20
> 	arch_clear_hugetlb_flags(folio);
> 	enqueue_hugetlb_folio(h, folio);
> @@ -1736,6 +1733,7 @@ void free_huge_folio(struct folio *folio)
> h->resv_huge_pages++;
>=20
> 	if (folio_test_hugetlb_temporary(folio)) {
> + 		folio_clear_hugetlb_temporary(folio);
> 	remove_hugetlb_folio(h, folio, false);
> 	spin_unlock_irqrestore(&hugetlb_lock, flags);
> 	update_and_free_hugetlb_folio(h, folio, true);
>=20
>=20
> --=20
> Best Regards,
> Yan, Zi



