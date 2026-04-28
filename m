Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 400A2FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B956B0093; Tue, 28 Apr 2026 08:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22676B0095; Tue, 28 Apr 2026 08:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938CB6B0096; Tue, 28 Apr 2026 08:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED1B6B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:13:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1809C12012D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:13:55 +0000 (UTC)
X-FDA: 84707856030.11.52380B2
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C76C100007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:13:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="liGzZ/6l";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777378433; a=rsa-sha256;
	cv=none;
	b=AM/ST/UzZO7O3lO7QCZhKPGIBAj5yHYjNopK7K/DqacEIqmyKP/OgEwI/KJOSd2DxKv/16
	7J/p4Q7GkiiWP4PNg0S/HZnNaWPgawormlS+oD+4AtXPxQf0e2rE/qeM0YL8+W6lgh2pHl
	T98tLYgmBXKqD4iQKhj/CKwwZV9fFlA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="liGzZ/6l";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777378433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMW0yphc9+JTsHgjuPXzpOHRe/+uClvfXBtsydm1QXs=;
	b=uCyVrvRKMReGdVBj8/hRsnodkWu8zjv/X2mQlfEdsXWQpWZi96czzJ69+qIgkpAG4qI5M8
	gfZNExxJ5mTziGEmsqT4Jme/Eq9kgWzUqO8Dwhh3LGZ13vfCIcuWIhZ/Lyokth1rAZ6y2a
	8beeZD8XTrUXPhc2SiWZTS6qZARBN+A=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777378430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gMW0yphc9+JTsHgjuPXzpOHRe/+uClvfXBtsydm1QXs=;
	b=liGzZ/6lcet38vVzKBuQrY39X3mLjaXryapTkWCkNSiDT8ppz7dunF9bMsRawPXG5pxkR5
	FhcWht8cZvdRPdpyR1p4MmEuMLHcB8c/dHAcKROxBElmkdgDF2smPjKbTZo6pmhUkCtZar
	glo2vu8yjY+mQkvZGqqftuaAu0NP3vQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBaMEBoR_35Fblc@kernel.org>
Date: Tue, 28 Apr 2026 20:13:05 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9FD13495-58E8-4183-AAC0-48E50A694ADE@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: n5qzdczja8hucf3himc3yjz5opneq8t1
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C76C100007
X-Rspamd-Server: rspam07
X-HE-Tag: 1777378432-539518
X-HE-Meta: U2FsdGVkX1+sRrWRHtS09lAUki56/iqb6fen1XN0pVTCZ8RS2Hp45E95K3RHXArOS/X/l5O2bu5/LjR9RdGU0weOVSngJViJkQPmdw5cpCyBvN2u65SPua3s/YupPfzMCV8v0oYDfV2QJJAHcBu7fLRt/MbnvbebHRpEusM6ODxbuKMI2Nkph0WulhMUryQ695I7cTWad3OZLQDRD1IBv8i9zBBeNaDWiYu+kN9QPZY7K1SFXrz9txIJdiaPjsCZIS+4Y0t/U2VlZxg2YML5gonDE+vzRqoO0bq3SamscQdts4JUUEdrljS+uNohgUr1ob8dfSOTzshviw6HgXrEwmvRaHyRcl6cRxydeWuJbjAdTwnEopx8WUXsHzSNOH+YkAFB7itEF8OxnM6ywZi5+q8U2XWxLsWdkwRgVMFXdAnMrDooT1JFENKhdJzu7M1ASf2Z/oMnLXU82bL8wmEIi3RP5i8rC3lro3ldo4/G9i6K5vIG4rPvvlAAqfvV6E++vlI8/2tV2ilR5vjbe6U8YJmnMf7f/r4+Hk0PjO57F4nQXeRgGSpMm1Mcu1HunOF7zSPo8ocsk4gDpJIFDtdH2PEe8YNdJvydmf2A35dNz5Y44HTMPqxCxQOkCwhJF0a6C0myUnPkWnob3DFtY2Vuqm6B6dmGFlC0fDqXYACjJH+MY6JcBVXjtui+xCzwiesqpli+Fcco6zPaqPieXdTu8l84Pz0g2DmkS7X7hxoJF8gDW/m70RHuh64YmwlyDyBaFj6YY9nTowl+IER0XkoqBDW6zowM2xWKxKIKA9xaGJYFp4gjBqpKPGZHuUwdy20JPEcu3dHXvf4zJQTXxDVXZNcXKkA1lW+d1ZCxl3uxK6MeuiFK5j2Q7ErnKOv8X3lf8tUI4hGhWq1hM8T9DyMr+WsNTd0J2jdgpWziqoLOQvo71Z3rPeQTX+Pd2fGPQ3HX0RCCj12vWczzRuOS67g
 DM5Oh1pw
 Xz755hXp10RN9O8VZrO3vs85uXiMhNCWAo2AuYOR4ZUyDSKkR1IuH+ZEOGfK2rLP1NDzN633neEcV9sAkwUunHxD9vN0fiCyoCn0J8XR0SC0HJFS3fleWf9OfHX724+uBrWSS34ppHTG1FKT2SLKe8Zmubuek28spL9/N3DEpI1XI4poNLT5PgMxGe63i4sD/1tatCSWiHDeJZ9wPnDxGBKxMg563uggu2Msc7U9qIwCsyauc5FvaUcITb6o18fifj9lDi7odMghIFmawQqOn8pPiarxDIm3Iqe5vRwwxewisSbSzm4O+X9DupqNWCgFkjO4yrZlEwZ6Cvg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 14:56, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Sun, Apr 05, 2026 at 08:52:00PM +0800, Muchun Song wrote:
>> When vmemmap pages allocation or usemap allocation fails, =
sparse_init_nid()
>> currently only marks the corresponding section as non-present. =
However,
>> subsequent code like memmap_init() iterating over PFNs does not check =
for
>> non-present sections, leading to invalid memory access (additional,
>> subsection_map_init() accessing the unallocated usemap as well).
>>=20
>> It is complex to audit and fix all boot-time PFN iterators to handle =
these
>> partially initialized sections correctly. Since vmemmap and usemap =
allocation
>> failures are extremely rare during early boot, the more appropriate =
approach
>> is to expose the problem as early as possible.
>>=20
>> Therefore, use BUG_ON() to panic immediately if allocation fails, =
instead of
>> attempting a partial recovery that leads to obscure crashes later.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>=20
>> ---
>> mm/sparse.c | 37 ++++++++-----------------------------
>> 1 file changed, 8 insertions(+), 29 deletions(-)
>>=20
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index effdac6b0ab1..5c12b979a618 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>>    unsigned long map_count)
>> {
>> 	unsigned long pnum;
>> - 	struct page *map;
>> - 	struct mem_section *ms;
>> -
>> - 	if (sparse_usage_init(nid, map_count)) {
>> - 		pr_err("%s: node[%d] usemap allocation failed", =
__func__, nid);
>> - 		goto failed;
>> - 	}
>>=20
>> + 	if (sparse_usage_init(nid, map_count))
>> + 		panic("The node[%d] usemap allocation failed\n", nid);
>=20
> Please consider using memblock_alloc_or_panic() in =
sparse_usage_init(), it
> would simplify the code even more.

Hi Mike,

Should we add a new function like memblock_alloc_node_or_panic? Because
we want to allocate vmemmap pages on the same node.

Thanks.



