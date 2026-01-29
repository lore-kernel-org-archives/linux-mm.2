Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18AE7D46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 03:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6146B0088; Wed, 28 Jan 2026 22:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793A96B0089; Wed, 28 Jan 2026 22:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B8C6B008A; Wed, 28 Jan 2026 22:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 554906B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:24:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17A2E14089E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:24:47 +0000 (UTC)
X-FDA: 84383559414.01.5D26A5D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DC8920006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:24:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xrnhdxRj;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769657085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlpBJ3KsRtrl9qZalE86QiWS9CLSHBJfdJXtnQNL1/E=;
	b=71GBRaKE07cFDPKLCNGEI7Zudanf5XxE1HcHeuXtPkGMiov7t6tA1KWo76CZgkTbhcUO6r
	RvmC1LeZA2HJBaP6Y74kwYl3taGwgLjMN6XnUMuAAEYDjhpxK5zU7LeQy75qUNkThPR3Wm
	qzImxewTPDVXU9cLy4Gf2R3zXObbvG0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xrnhdxRj;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769657085; a=rsa-sha256;
	cv=none;
	b=MdPM0+3MROStNNT0qTePTnf2O1aobEWra5ZERLokd5NLkn6CmMYU6puLB6o1MHGtDiZfEv
	+IzwbQdA4StlgpJ20oALoUulIaQMhqOd2sJ8mLISc897F4Q1MfJkFrKiFM19U3src7GPoK
	FfIHiztYDXF5lNBgM/xTf8EUPCU88Mw=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769657083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FlpBJ3KsRtrl9qZalE86QiWS9CLSHBJfdJXtnQNL1/E=;
	b=xrnhdxRjcG4kB4MkJDyhfeORdlppD3+zJ5DOkDLnPPMhNmq4pItIrLdIWdlbQ5bOfFPtzI
	2XvhH+gI5l2dPkM9vCOS7iB0kedN4fDHy/+JYv7wyEQO+5C2234LkvgZe1Txj7AK8u0BU4
	kmo7++P9v4E+IufxVhR5D2jNrY1NhV8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv5 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <3DA11168-5E37-4CE9-9934-CD1CAF3085D6@nvidia.com>
Date: Thu, 29 Jan 2026 11:23:58 +0800
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A08D224-E1AC-4FE5-B1D0-1BAE2D5FF31E@linux.dev>
References: <20260128135500.22121-1-kas@kernel.org>
 <20260128135500.22121-10-kas@kernel.org>
 <B4674CF0-7534-462B-A761-D9124234BFE4@linux.dev>
 <3DA11168-5E37-4CE9-9934-CD1CAF3085D6@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5DC8920006
X-Stat-Signature: gruxf5dnpcd9qdf1pj3qtkecxbyg3x39
X-Rspam-User: 
X-HE-Tag: 1769657085-268484
X-HE-Meta: U2FsdGVkX189k5oCRj1b+xtC6ziLqhKtH1JRL3SEA0r4uGOpWLp/ErjYp134sFeuEAe9tc1eXq67+7zc7d/MHe7FAjBvhUxWh84fSpd5jtap17x34bRd+McIER9pKmd6aCp9eIF0OnDrpoLdItC3es9Rl/bL3lNU90wE3NUyhI7XqvMJW7TfgylQRtxzR+9Z558dyAoK+NeUoj6lc6FPohPIoTBnpvSt4SA59oGinDRespxqNQbwKFvpr06ERikIiUB218Cqmcb3MIdst6JpIsADl/CIEQJgEXN/x3j/tnF7U26M2Et55rVbtljB3TtRj7cWwtO2j0WGhEHvK3Q/elHCIJo5xa4SGLYk/AfPoQv2m7+fapUBxYe7B+tjYiBIBuLC1NUSlMQy2dDji1VVlID4jengC7jtRsy4OIH7H8eQ0yMKLFWEYLRMKi3hVQLtVATxWyg7YDf7dSJT8BT+AEpXpaLv5orBPSr+rQRnFRWIEic3/gNdHbl5AouGk/vIW2rDapa8KWqEEBO/5KKXzu1coRCgSNuCG4CQkocMeSoS1n2y95VdW/ROXX4Wc/G3UjDKpL+a4S9rrfKecHlc0YZtZGs1O/dpKIcjCBiItngleHCyrhQyuI6UtiYPNSZnJ6jB2S8vUQIIYHSTB2js5cx243wER3Ivv9jhgTLia6/NzQpJYnuudzbQ9FI2EHZPChW6CwO8o7Lud/5aHqUK/59d12axgbRHbAzUg6P/4n+o7Sg/Ozx71QG8IvppRVUjypT8ETsmDXhgx1b+v38QWQkD7qZjKjHZG2cEzoWs7rxg73go0a7fPJlIEICZ8x7P6IFYBx1Nt45j2/2NUsaTKRSIf0VEJ5hOwUS8TXBVH/dHrrkuE+KRwL4KCbA+jDm9TkbPbzw2hNC5+4VVS+l+AyPmzv1fI/oAz43spEKoIMiTcLwn87TkmOM1uaek5xsgkqQze8hBWNWuV6j6Vj/
 Q5q0JSPv
 C3EWCTUAMaYDqyKdXpT0Xs2LS0G49/jO1Lkunfs1m6ZZizOYYqrGBElQUlLULkgzDrVZc8pNdn+etjd6izUCPnw3VSWZyHWfX+AbKBcn6K0XtIaRsalglthFhmdEtGv5DgOp+ysEY6kKwi09c1q6Yv0VbJnqUtrZDGeFEv2Nb1g0Vbw3/R87uVdt6+bArtdtDuMXuoq/GFkVs5e2OLhowt7nIOhnZct6HLkfLhDWcVNBqj58t4g71n+fVwP4KTTJDV0DWUhVHewlu0wvT2cihIpdHYiGqTrlZg3wWCzVipY57Yy09Wx+Y9zN76Ry5SMyqCX02VUtkm6HYZkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 29, 2026, at 11:10, Zi Yan <ziy@nvidia.com> wrote:
>=20
> On 28 Jan 2026, at 22:00, Muchun Song wrote:
>=20
>>> On Jan 28, 2026, at 21:54, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>=20
>>> If page->compound_info encodes a mask, it is expected that vmemmap =
to be
>>> naturally aligned to the maximum folio size.
>>>=20
>>> Trigger a BUG() for CONFIG_DEBUG_VM=3Dy or WARN() otherwise.
>>>=20
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>> mm/sparse.c | 13 +++++++++++++
>>> 1 file changed, 13 insertions(+)
>>>=20
>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>> index b5b2b6f7041b..9c0f4015778c 100644
>>> --- a/mm/sparse.c
>>> +++ b/mm/sparse.c
>>> @@ -600,6 +600,19 @@ void __init sparse_init(void)
>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>> memblocks_present();
>>>=20
>>> +  if (compound_info_has_mask()) {
>>> +  	unsigned long alignment;
>>> +  	bool aligned;
>>> +
>>> +  	alignment =3D MAX_FOLIO_NR_PAGES * sizeof(struct page);
>>> +  	aligned =3D IS_ALIGNED((unsigned long) pfn_to_page(0), =
alignment);
>>> +
>>> +  	if (IS_ENABLED(CONFIG_DEBUG_VM))
>>> +  		BUG_ON(!aligned);
>>> +  	else
>>> +  		WARN_ON(!aligned);
>>=20
>> Since you=E2=80=99ve fixed all the problematic architectures, I =
don=E2=80=99t believe
>> we=E2=80=99ll ever hit the WARN or BUG here anymore.
>>=20
>> I think we can now simplify the code further and just use VM_BUG_ON:
>> if any architecture changes in the future, the misalignment will be
>> caught during testing, so we won=E2=80=99t need to worry about it at =
run-time.
>>=20
>=20
> VM_WARN_ON should be sufficient, since bots should report warnings
> from any patch/change.

I=E2=80=99m not sure a WARN will get developers=E2=80=99 attention, =
since the message
is unlikely to have any visible consequences and only fires on
allocations with a special order.

>=20
>>> +  }
>>> +
>>> pnum_begin =3D first_present_section_nr();
>>> nid_begin =3D sparse_early_nid(__nr_to_section(pnum_begin));
>>>=20
>>> --=20
>>> 2.51.2
>>>=20
>=20
>=20
> Best Regards,
> Yan, Zi



