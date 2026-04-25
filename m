Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13154FF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 06:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442E96B0005; Sat, 25 Apr 2026 02:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3306B008A; Sat, 25 Apr 2026 02:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A166B008C; Sat, 25 Apr 2026 02:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 231246B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:21:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 791CC12028F
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:21:20 +0000 (UTC)
X-FDA: 84696081120.18.9F5253F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F8EF40008
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:21:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZCQSa0xM;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777098078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHZLJC5B5fmgRAOtQknXGM+s5bBWV7trEmZX8TH0Pyk=;
	b=i9Sj9PpusDVxziS/KvEAq1nMmKD4v6XmYPc2f3SRxMa2Rz5hDtdVvI/ZQo0EC+ocwa1Wh7
	MbTIPWFrkCXMOm4Zg92YQLN1ljsLCCMvuUxji98xAgiJwZDzI5eRHz8cBhJFeEe5toPVbG
	xx+5bSb/hrn8rq0a+JsU8YZCMBnUb/E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZCQSa0xM;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777098078; a=rsa-sha256;
	cv=none;
	b=tLHzyPAY/Vz/k259eS95JAmyUfxtNZ9vMTPrdGYM7dr0sxUn+NoxF6u3DXnMiU97/rV5K/
	X2az1u9iT6GyApv8etxC0QsEWQl0imWP8lGdSHRRD8noZcmCXRgWKOWYAgfmWsRiqXnK1J
	I7U3q5r24USC5piZLEDYa1XPagtjDBw=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777098076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DHZLJC5B5fmgRAOtQknXGM+s5bBWV7trEmZX8TH0Pyk=;
	b=ZCQSa0xMAWeLz4zqajISETfXw0jpqKglaKesdUOywfIFOqHdjirtt+ma6LodskeBqPJfos
	2sHx8WiBaja3NZLDcHxvFAt1HvSgu28BujosBA5ALe9pIqvU8pMspNe8EEj4HliRx0V/0y
	I+S/2Px5CbIdsYh0eu/l0FH2uqJGXlQ=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Sat, 25 Apr 2026 14:20:39 +0800
Message-Id: <17902B08-7487-4FC8-8EBC-268CE5F3E1B9@linux.dev>
References: <02e35414-8c30-4753-9403-432d90263f39@kernel.org>
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
In-Reply-To: <02e35414-8c30-4753-9403-432d90263f39@kernel.org>
To: David Hildenbrand <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F8EF40008
X-Stat-Signature: c1tu6mgpnt89xccwj5ozrdzu3559a95n
X-HE-Tag: 1777098078-826913
X-HE-Meta: U2FsdGVkX19uF4OzQI5daiK9R6jXdMgHBn5STyOVmAd2dkIwps59EYDOvob1iUX8vlUjICIEklv2O7YC5ovrG9LVffhp0niKdYFzZieVXtddU5KVfVRo3bcquApbPnVpmLNOavBLNBiJBBt/F1plqsOCC529eHHKBsiahXwA9pDtSWNNzfxg4Z3f+bV41JuRZy/V/xNrLUc8LK8+rS9H43EMtHLhuGEb6cueqSW3S0SDGRHjuaUT3fm8xBi7sbTtx1aT2Xj2ZeI67FO3VUhkw3J/8GqT23f9ybznCH57OmAKAuai+DRQuJ2pZhr9NF9hoTYWOU19W+BhR2yLCJZARpXugMtRwk/4tzNfFblLFE9yI75vqU7HhMxUvNoVvD1KMFAIG8fGIh6xIdWu2Kq6L0Bwl6nIrAHBJKXBkywRoIh1wJPCyoJOh8ouGCTXn5cwPanRgHYM4a4/4SgJDLbko5uN3vTZYctcB7p3vfzhk5tbhCvAso5+oe8zN56SYHLurQbnRnc1ba0jyOkanbTLAadDJnw7aswDDDinU6Rvctn7E8Y1OzCRj3mMEy+8EU8w+6AeU3599mC8VCS1E+GuSGQd3+kzNDH1EFcMMrzuYN90i9lNEImP6q5pUuHlBUuY0gJ4Mxf200gQePkg61wSXyc6YmLCSIQGadJ5k2Ym7CepXhIdw1g+vVKFKahpO+w9JI7fniy4fRLTscrN0R8niN8sK7Y3yOV+UA92x1v21EE9IfvwiXkq2bbONMn4EHxvZifG1nydVllp9AUbr8Er2+Wcva2xWF4gCThj7VkPcLAM9Q25XUo3SP/vvREJJMPEmO5lymuIU24r12JrLjk5zy6b13jc56++e+Ef2PxLMWigE0kyurB56k3MtawOkJC0IJwn1lOfsBSmp0vEW5MQtOJj5inzUm2EDHuBWk22RxghiNKPP8DIeWF433dUz022bhXBTd1QKB0y+P1yiL0
 f3ZMybu4
 PrmRpcDW1WOt6pzN+qvAd4vtUBmdXeE4JbPGqUAEhzYDtpSH1uSPBMHAT4U7cHQqDYHqAaQqI1BfKA3rpeYRarGM+Ux9zM1AmResybHDMr5QxrhHjbpzET0wFazBeX1HAE4kcJoNXwYf8V+hxAnqIEj3vpyHTbYy5FPoQjHUwrcddgNOOyOmu3JkjAWhSbbKf5YDw2MZ5EmbtYVcoYOpVw5MrW9KuEUH8iPlIwJ92nItE/kc2Jne8UsU5VRKZ/eKwTH8J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 25, 2026, at 13:48, David Hildenbrand (Arm) <david@kernel.org> wrot=
e:
>=20
> =EF=BB=BF
>>=20
>>=20
>> Hi David,
>>=20
>> Sorry, I missed the 1GB hugepage scenario earlier. Given that sparse_add_=
section()
>> operates on a scale between PAGES_PER_SUBSECTION and PAGES_PER_SECTION, t=
he pfn and
>> nr_pages parameters wouldn't be aligned with the hugepage size (pages_per=
_compound),
>> but rather with the PAGES_PER_SECTION boundary. Do you think this explana=
tion makes
>> it clearer? In the interest of code clarity, do you think the modificatio=
n below
>> makes it easier to follow?
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 2e642c5ff3f2..ce675c5fb94d 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -658,15 +658,18 @@ static int __meminit section_nr_vmemmap_pages(unsig=
ned long pfn, unsigned long n
>>        const unsigned int order =3D pgmap ? pgmap->vmemmap_shift : 0;
>>        const unsigned long pages_per_compound =3D 1UL << order;
>>=20
>> -       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
>> -                                   min(pages_per_compound, PAGES_PER_SEC=
TION)));
>> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION)=
);
>=20
> That here makes sense. We can only add/remove in multiples of PAGES_PER_SE=
CTION.
> I think what we are saying is that we want that check in addition to the
> existing min() check.

Right.

>=20
>>        VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) !=3D pfn_to_section_nr(pfn +=
 nr_pages - 1));
>>=20
>>        if (!vmemmap_can_optimize(altmap, pgmap))
>>                return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_S=
IZE);
>>=20
>> -       if (order < PFN_SECTION_SHIFT)
>> +       if (order < PFN_SECTION_SHIFT) {
>> +               VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_com=
pound));
>>                return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;=

>=20
> That makes sense as well, within a section, we expect that we always add/r=
emove
> entire "compound"-managed chunks.
>=20
>> +       }
>> +
>> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>=20
> And this is then for the case where a 1G page spans multiple sections, whe=
re we
> expect to add/remove an entire section.
>=20
> So here, indeed the "min" makes sense. I guess we also assume:
>=20
>    VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);

Yes. But this one we do not need to explicit it to
assert it since at the front of this function we have

VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) !=3D pfn_to_section_nr(pfn + nr_pages=
 - 1));

to make sure the passing range belongs to one section.

Thanks.

>=20
> Looks better to me!
>=20
> --
> Cheers,
>=20
> David

