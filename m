Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF58BD46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 03:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3DA6B0088; Wed, 28 Jan 2026 22:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1E76B0089; Wed, 28 Jan 2026 22:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283886B008A; Wed, 28 Jan 2026 22:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 186156B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:05:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3EF81A0884
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:05:38 +0000 (UTC)
X-FDA: 84383511156.01.76F5E46
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 70ECA40005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:05:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=huWhiz1w;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769655935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=an0cSs0GytVePatdoHmbGbyCizuHZjF2ab0BxwHmZLU=;
	b=EwbyyNwXW/OK5wSijW4rmdZAUw8NLbpmZMqLYHjm/eJiZweQoVZgHSCLPdg8gsLeKEI6d1
	S7n7kKHi2HGFtw6RYg4SNEeOWlqXcSD+E4DksEFzcUdEgK2bq6m/nfdidL6kdKGDYuJjaE
	UE1H76snvBJghYlxJ+aaHjpO43E9bg4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=huWhiz1w;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769655935; a=rsa-sha256;
	cv=none;
	b=IXx9HV5xMW3HJLlYskJkG2LtcVwxlErL4XVxnjOMZ+mEm119yyaO89mjFPXrVBWyIasXTv
	zNjlPi9jcUrU3KryzkTzKlXlZYrhFQ+ZJ6fSQRaawtUxC6N9VGlQ+b3RbVzTn/SEPqE8Qo
	Rn/VWsBFYlhVqv6z/hDT1snJpKRw9bE=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769655932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=an0cSs0GytVePatdoHmbGbyCizuHZjF2ab0BxwHmZLU=;
	b=huWhiz1wekIwHSdbnJbtxQhrvvGoKBz9P5Qnh5MFrkRE4/aIY2UhUCfsqagQMlYsYnfb7/
	v8deIDW5nWZ26ZpvuZf1+WS1BBDhtE/rjb50VwIMP4Nnc8uluXO+7rJ7tp1Eikp59O5dxJ
	de0tQUCZRH2ZcTwTOtMAKATYFLeZ3sk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 09/14] mm/hugetlb: Remove fake head pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aXoHb5fYfZNQxmMe@thinkstation>
Date: Thu, 29 Jan 2026 11:04:53 +0800
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
Message-Id: <7BD81F46-74A0-4991-8B32-67E5DBC682B3@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-10-kas@kernel.org>
 <ffe9811b-d7f8-4924-9ad6-96057a16b693@linux.dev>
 <aXjPf_fIWX74YVWD@thinkstation>
 <25C01EB2-FC77-43A5-A737-7BD3D2D98EDE@linux.dev>
 <aXoHb5fYfZNQxmMe@thinkstation>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zohq4ciqpjkmxscjz9zkw1ujpzqjk8hu
X-Rspamd-Queue-Id: 70ECA40005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769655935-164995
X-HE-Meta: U2FsdGVkX1/HTVjLhgAgw0duOjliTa0bsF1AhqDIU7JDOg40/3S/HUwTT7gHPK4mZhsia0IszqllUxhDjyWV59sc5Y2eNDvjVYMeSLQCH8vU0uDTQq507qU70SujdrDDWa7amGTQNM11/XMvPynXoWNmyKGevPaOTGQtn7nZz38GQsWEi5LEoLN73MxXfGuVWN45wjfvB4CIybzKSBfeJPjRe2fpWlY3IbMIleqjDJkoaGJNZ6USwhMJtP4Adcsoyr2xcIFWtQ88IpCMKCDSbeQE1DF4QPxBejbZyUgoKBq20GKQy2S54b2fuqAuUjVaVcgdI+GBv6Y7KVKD7OSAiR0FGYkV7YGWhf5/be5+mW83PaJjovizZCao6H6ewV/k/lOMGtd5LZeMnyYHDX7brSW2QXjMC/gfCqloF2MsG38XeB+9d8IeFsT28aqXAzGxjYLV72fJqrylasUwZD8jjDxaPBFBCeHxuELTH4EGid2eX/hFL/dydeAAuXADCmaQrkUlXBiqJMRUroZVDnAc+aT3lAh9Bd9OmuPoqHh7jebjgUBmcn5odKrCtE8QsuqoankJZX/dgyexz1t5y4J5EJOTy+zwjjWmlxMurU3NNozEN/q1urLluzSPQsVRGAnqShlLoMwT4jrnhfKeq1tNuDsBhQqPjxfgFwD80nn6gP5Q+v/YfaY70xR+7IqzWZRgrR4kTw6eiMzUqG6+wI+6D3yWaGqoBh3XR2VTw64cqNcI/pzinogSJI7OVJP4Q6rNEU+UGIT+wKVd695qh92YScp2gLFwzcyG60y619eZgKffUeUxIMZfjHhOLqhdckxGy36h+IuhKFh/dKSRULFMlWgBYXXpyJ00UBFyGVVxIM09GF/64QSoWnZUL7hgBefOwPBDwVEDGFBkuGFvbBpCVDDXtTr3ldkhbQEHN8t3equLQI8qkVbXWixNGNVjFgYQdLgPJ4ad7g9hYfCdSPI
 i8LPqn/r
 R0WHxLBRA27UVfrnGmyLwbOUchCMx3zJWAnHtQGNALnefn1X9pKvgKQlsWcvGSXS3eT9aEOw7Zh1S7Vz0Bapfq+fto2b8G+tuTtQMSxh/F7/GHMVYE2FUOVTvfY2CTDvnuCNuXpWm/aKEfjoeU0zLWyWYKs9CuX8zZTzz7kvqTDf+8fRZb0lSW/jgdohUhj/YLUMAoc2QXu+GUW8R6Uc2cS4QNdoTK10kVtxxaOJAWL7+1TkLnyXWe5BETuPs0pTK8uDjjs4svp7JzSG1nmEZ2cR6qRFk2IdljgWy3J3FsIyWZvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 28, 2026, at 20:59, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> On Wed, Jan 28, 2026 at 10:43:13AM +0800, Muchun Song wrote:
>>=20
>>=20
>>> On Jan 27, 2026, at 22:51, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> On Thu, Jan 22, 2026 at 03:00:03PM +0800, Muchun Song wrote:
>>>>> + if (pfn)
>>>>> +  return pfn_to_page(pfn);
>>>>> +
>>>>> + tail =3D alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
>>>>> + if (!tail)
>>>>> +  return NULL;
>>>>> +
>>>>> + p =3D page_to_virt(tail);
>>>>> + for (int i =3D 0; i < PAGE_SIZE / sizeof(struct page); i++)
>>>>> +  prep_compound_tail(p + i, NULL, order);
>>>>> +
>>>>> + spin_lock(&hugetlb_lock);
>>>>=20
>>>> hugetlb_lock is considered a contended lock, better not to abuse =
it.
>>>> cmpxchg() is enought in this case.
>>>=20
>>> We hit the lock once per node (excluding races). Its contribution to =
the
>>> lock contention is negligible. spin_lock() is easier to follow. I =
will
>>> keep it.
>>=20
>> I don't think cmpxchg() is hard to follow. It=E2=80=99s precisely =
because of
>> your abuse that interrupts still have to be disabled =
here=E2=80=94hugetlb_lock
>> must be an irq-off lock. Are you really going to use spin_lock_irq =
just
>> because =E2=80=9Cit feels simpler=E2=80=9D to you?
>=20
> I looked again at it and reconsidered. I will use cmpxchg(), but =
mostly
> because hugetlb_lock is a bad fit to protect anything in pg_data_t.
> vmemmap_tails can be used by code outside hugetlb.
>=20
> Here's the fixup.
>=20
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 29e9bbb43178..63e7ca85c8c9 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -512,18 +512,11 @@ static struct page *vmemmap_get_tail(unsigned =
int order, int node)
> 	for (int i =3D 0; i < PAGE_SIZE / sizeof(struct page); i++)
> 		prep_compound_tail(p + i, NULL, order);
>=20
> - 	spin_lock(&hugetlb_lock);
> - 	if (!NODE_DATA(node)->vmemmap_tails[idx]) {
> - 		pfn =3D PHYS_PFN(virt_to_phys(p));
> - 		NODE_DATA(node)->vmemmap_tails[idx] =3D pfn;
> - 		tail =3D NULL;
> - 	} else {
> - 		pfn =3D NODE_DATA(node)->vmemmap_tails[idx];
> - 	}
> - 	spin_unlock(&hugetlb_lock);
> -
> - 	if (tail)
> + 	pfn =3D PHYS_PFN(virt_to_phys(p));
> + 	if (cmpxchg(&NODE_DATA(node)->vmemmap_tails[idx], 0, pfn)) {
> 		__free_page(tail);
> + 		pfn =3D READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
> + 	}

Simpler than before.

>=20
> 	return pfn_to_page(pfn);
> }
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov



