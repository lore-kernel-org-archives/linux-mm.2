Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36A7F34C50
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E036B0089; Mon, 13 Apr 2026 08:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8066B008A; Mon, 13 Apr 2026 08:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1A16B0092; Mon, 13 Apr 2026 08:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6AB96B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:48:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B7EA888E1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:48:16 +0000 (UTC)
X-FDA: 84653510592.17.C0B18A3
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7A56B140006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:48:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nE5VYNAw;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776084495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdfAjxhRsl2+AREvfePGH23u3lRiFYRNi2DHKhHln2k=;
	b=Z6SdPP2tdz6tWLtCtoyVCKlQMwUxadf0i8TfQn8Jr4UaKklQLxNsElXiUyMPNIrFJn8YvO
	BJJJKCls2RYeAtn94T7DbDKF5Bmee55XBd1YAO+WlArhNhBF8hcsmngIXWrygLoDVZNH8W
	XyxBySjDLOzzYzx1vKkwi/lXsoaa1c4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776084495; a=rsa-sha256;
	cv=none;
	b=Ne7W7MU+jxRKRL2t0pL8/tutBJimI+bKFDcWIk+JFsD/J8EGZnQLxKBiN12lAwlAItrAGm
	r5I7+5v2KpKJaszsgD3B9l/f8KcGy12QsVwLpXZ4Lc2j/5f3fopRWa6OOiDXhcN8Z73ABv
	zScq6AhqpQhOHL8mv2SG4hVVSNjXZQM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nE5VYNAw;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776084492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdfAjxhRsl2+AREvfePGH23u3lRiFYRNi2DHKhHln2k=;
	b=nE5VYNAwk/69hYOoOByq/8wh/JZBJg16bR2vH8D/XiuneHiHEafQ/FFFrao5O/GxJPSdv1
	0/soNVIqBY9ziLV6FXp9cYu6u64On/Asc235Aazy8XEamU408vuxPmoSSxPdkhcsqXYf4+
	9zBfORBJFl+gW2g0jIAnGHjOPH3i/mc=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
Date: Mon, 13 Apr 2026 20:47:45 +0800
Message-Id: <8AEA6BCE-570F-4095-ADCF-9699BDE0DD64@linux.dev>
References: <adzb5o9aWxFWphRK@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <adzb5o9aWxFWphRK@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7A56B140006
X-Stat-Signature: gf6df8tspwq3jj1n6dqcakzp5gwr984k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776084494-201065
X-HE-Meta: U2FsdGVkX18iGE5vKRSb0Hi7upJRFPYyTWXY3RVUKAv9s0cIWEIz1cHwBMxNNzqydfCfPMJDS48yffzA4v1a0+fzsKqqSvnRGGJ8YEQM/tpXl7ImwmyftD5JPfO4urjyongtNKXAlzwl68plFdiLhIaiP1S2oNpcLOV8q1kRNDN3DiAm0R1KbpH3xih1VvEYQ3yEaczNeYCW6NURwXwAVXw2No23cAVPTptmCTp1Z9zhnDMexT5CDnD/9qE1F7zz1MNncgsTfy0t7lsm4zJczHMyb3iySAiu/DOnfH0ctOH7XYmkdrBRN8m0QS+f2oBcjjjJasS7kOaVqunpWwbF1f/oJFtL1bwqr2YR3CUSQnJmkf35DsXc51AGLAjuqE50XgqkpB/hNuy+J5fGjvZmF2J0qPNJ02gVnF3xVud/Y0Phc1vhv6qD+TFXIfiWbD3tW4VzsYNGyHWKffaYShfYHm30cQSTL1xn6KWAbOozrfRHq0ok5bBY4aBeChPKyrGGtOmwrSGvTvyOXtQ7awn6AytNbGn2yMcLKCbLad/QKAFr3yNfTdnnsCojELfkvaPeFYB/4Zf/Pkn5PWb+0VdC9m8ZZv3iFNKojUtNhErghOsn1hcf+HkHIVB/TGDOjtkF2521XpIDE7P1qT9arB9u15w9uig6cQm3p4DU8cO6qDW1ugBKmLBWGRBrU9mQ+W5FQ9kjj5QC52Uftcm9OBTNLHD0lFOJurg0Ik+l6LVYK5rIBij/hxbBWNR6Kg0WaocyYZRCcXf1tBgaNK3QQaeRzBkTkionJpR7Gxm50Gbk2KmxTzyajZuF56TpY7tY0242YFuHe8CYBIAsu+UPt9reCjGINrOnXcjMx7UfD6FNrUwVSsr+kAnYKvQuVzlYtmjoP3GSv2UCm/OvmoGXbAPVtU3TqunDZUOTJmfCtS479a7DYVsw8yxObxUYlWzEwaItarFLVkXQ/lRbTlhIrwO
 cbbhVovI
 udDUEYX90QaRH8WYv+BnT50juJ0pLnadaJVfEq0hOvyHQ/hs123ln3KRMSot5BMVT5gv7ve+Dx5PcEopYXIKzORTGCrWE7Lop9tgoHmB2OiDbFjb3qbjjpaH636Tuk9iwFKM4SiFLClnJYmiDRGNiq50nnGni0iz3+qMsYR7qZEnLcl6nH8FuZfgK9zRdzyQ65jy6+8Hu6/1h13cXHVaAv4ewGnocbRBXQngu7gkmnBRM6wxCZX2xjxFRXnkoqD9V44e97mIZhtY06lro5Gu58DGp7Mk4d06GJNiM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Sent from my iPad

> On Apr 13, 2026, at 20:05, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> =EF=BB=BFOn Mon, Apr 13, 2026 at 05:49:17PM +0800, Muchun Song wrote:
>>=20
>>=20
>>>> On Apr 13, 2026, at 17:35, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> On Mon, Apr 13, 2026 at 12:19:50PM +0300, Mike Rapoport wrote:
>>>> On Sun, Apr 05, 2026 at 08:51:52PM +0800, Muchun Song wrote:
>>>>> In section_activate(), if populate_section_memmap() fails, the error
>>>>> handling path calls section_deactivate() to roll back the state. This
>>>>> approach introduces an accounting imbalance.
>>>>>=20
>>>>> Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
>>>>> memmap pages are accounted for only after populate_section_memmap()
>>>>> succeeds. However, section_deactivate() unconditionally decrements the=

>>>>> vmemmap account. Consequently, a failure in populate_section_memmap()
>>>>> leads to a negative offset (underflow) in the system's vmemmap trackin=
g.
>>>>>=20
>>>>> We can fix this by ensuring that the vmemmap accounting is incremented=

>>>>> immediately before checking for the success of populate_section_memmap=
().
>>>>> If populate_section_memmap() fails, the subsequent call to
>>>>> section_deactivate() will decrement the accounting, perfectly offsetti=
ng
>>>>> the increment and maintaining balance.
>>>>>=20
>>>>> Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>> ---
>>>>> mm/sparse-vmemmap.c | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>=20
>>>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>>>> index 6eadb9d116e4..ee27d0c0efe2 100644
>>>>> --- a/mm/sparse-vmemmap.c
>>>>> +++ b/mm/sparse-vmemmap.c
>>>>> @@ -822,11 +822,11 @@ static struct page * __meminit section_activate(=
int nid, unsigned long pfn,
>>>>> return pfn_to_page(pfn);
>>>>>=20
>>>>> memmap =3D populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);=

>>>>> + memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_S=
IZE));
>>>>=20
>>>> This logically belongs to success path in populate_section_memmap(). If=
 we
>>>> update the counter there, we won't need to temporarily increase it at a=
ll.
>>>=20
>>> Not strictly related to this patchset, but it seems, we can have a singl=
e
>>> memmap_boot_pages_add() in memmap_alloc() rather than to update the coun=
ter
>>> in memmap_alloc() callers.
>>=20
>> It will indeed become simpler and is a good cleanup direction, but there
>> is a slight change in semantics: the page tables used for vmemmap page
>> mapping will also be counted in memmap_boot_pages_add(). This might not
>> be an issue (after all, the size of the page tables is very small compare=
d
>> to struct pages, right?).
>>=20
>> Additionally, I still lean toward making no changes to this patch, becaus=
e
>> this is a pure bugfix patch =E2=80=94 of course, it is meant to facilitat=
e backporting
>> for those who need it. The cleanup would involve many more changes, so I
>> prefer to do that in a separate patch. What do you think?
>=20
> For this patch and easy backporting I still think that cleaner to have the=

> counter incremented in populate_section_memmap() rather immediately after
> it.

Hi Mike,

Alright, let=E2=80=99s revisit your solution. After we=E2=80=99ve moved the c=
ounter into the=20
populate_section_memmap(), we still need to increase the counter temporarily=

(but in populate_section_memmap()) even if we fail to populate. That=E2=80=99=
s
because section_deactivate() reduces the counter without exception, isn=E2=80=
=99t it?
Just want to make sure we are on the same page on the meaning of =E2=80=9Cte=
mporarily
increase=E2=80=9D.  Maybe you do not mean =E2=80=9Ctemporarily=E2=80=9D in t=
his case.

Thanks,
Muchun.

>=20
>> Thanks,
>> Muchun.
>>=20
>>>=20
>>>>> if (!memmap) {
>>>>> section_deactivate(pfn, nr_pages, altmap);
>>>>> return ERR_PTR(-ENOMEM);
>>>>> }
>>>>> - memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_S=
IZE));
>>>>>=20
>>>>> return memmap;
>>>>> }
>>>>> --
>>>>> 2.20.1
>>>>>=20
>>>>=20
>>>> --
>>>> Sincerely yours,
>>>> Mike.
>>>=20
>>> --
>>> Sincerely yours,
>>> Mike.
>>=20
>>=20
>>=20
>=20
> --
> Sincerely yours,
> Mike.

